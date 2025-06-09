module Logger
  def log_info(message)
    log_entry("info", message)
  end

  def log_warning(message)
    log_entry("warning", message)
  end

  def log_error(message)
    log_entry("error", message)
  end

  private

  def log_entry(log_type, message)
    timestamp = Time.now.iso8601
    log_line = "#{timestamp} -- #{log_type} -- #{message}\n"
    File.open("app.log", "a") { |file| file.write(log_line) }
  end
end

class User
  attr_reader :name
  attr_accessor :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end
end

class Transaction
  attr_reader :user, :value

  def initialize(user, value)
    @user = user
    @value = value
    freeze # Make the object immutable
  end

  def to_s
    "User #{user.name} transaction with value #{value}"
  end
end

class Bank
  def process_transactions(transactions, &callback)
    raise NotImplementedError, "This is an abstract method"
  end
end

class CBABank < Bank
  include Logger

  def initialize(users)
    @users = users
  end

  def process_transactions(transactions, &callback)
    log_info("Processing Transactions #{transactions.join(', ')}...")

    transactions.each do |transaction|
      process_transaction(transaction, &callback)
    end
  end

  private

  def process_transaction(transaction, &callback)
    unless @users.include?(transaction.user)
      message = "#{transaction.user.name} not exist in the bank!!"
      log_error("#{transaction} failed with message #{message}")
      callback.call(false, transaction, message)
      return
    end

    begin
      new_balance = transaction.user.balance + transaction.value
      if new_balance < 0
        raise "Not enough balance"
      end

      transaction.user.balance = new_balance

      if transaction.user.balance == 0
        log_warning("#{transaction.user.name} has 0 balance")
      end

      log_info("#{transaction} succeeded")
      callback.call(true, transaction, nil)
    rescue => e
      log_error("#{transaction} failed with message #{e.message}")
      callback.call(false, transaction, e.message)
    end
  end
end

users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100)
]

out_side_bank_users = [
  User.new("Menna", 400),
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(out_side_bank_users[0], -100)
]

File.delete("app.log") if File.exist?("app.log")

bank = CBABank.new(users)

callback = lambda do |success, transaction, message|
  if success
    puts "Call endpoint for success of #{transaction}"
  else
    puts "Call endpoint for failure of #{transaction} with reason #{message}"
  end
end

bank.process_transactions(transactions, &callback)
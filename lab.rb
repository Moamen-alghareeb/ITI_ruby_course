require 'json'

def clear_screen
    system('cls') || system('clear') || puts("\e[H\e[2J")
end


class Inventory
    attr_accessor :books
    attr_reader :path
    def initialize
        @books = Hash[]
        @path = "library.json"

    end

    def add_book(title,author,isbn)
        @books[isbn] = {:"Title" => title , :"Author" => author , :"Isbn" => isbn}
        save_books()
    end

    def remove_book(isbn)
        @books.delete(isbn)
        save_books()
    end

    def check_book_existance?(isbn)
        @books.has_key?(isbn)
    end
    def display_books
        json_data = File.read(@path)
        @books = JSON.parse(json_data)
        if @books.size > 0
            @books.each {|key,value| puts "**********Book*******\nTitle: #{value["Title"]} \nAuthor:  #{value["Author"]} \nISBN: #{value["Isbn"]}"}
        else
            puts "no books found"
        end
    end
    
    def save_books()
        books_json =  JSON.pretty_generate(@books)
        # books_json.each_value {|value| value = JSON.generate(value)}
        File.open(@path, "w") do |file|
            file.puts(books_json)
        end
    end
end
    inventory = Inventory.new

menu_flag = true
while menu_flag == true
    puts "***************** Menu ***************"
    puts "1-List books"
    puts "2-Add book"
    puts "3-remove book By ISBN"
    puts "4-exit"

    command = gets.chomp.to_i
    clear_screen
    case command
        when 1
            inventory.display_books
            puts "***********enter any key to continue"
            clr = gets.chomp
            clear_screen
        when 2
            puts "************adding book************"
            puts "please enter book's title:"
            book_title = gets.chomp
            puts "please enter book's author:"
            book_author = gets.chomp
            puts "please enter book's isbn:"
            book_isbn = gets.chomp
            inventory.add_book(book_title,book_author,book_isbn)
            puts "***********book added successfully, enter any key to continue"
            clr = gets.chomp
            clear_screen
        when 3
            puts "************removing book************"
            puts "please enter book's isbn:"
            book_isbn = gets.chomp
            if(inventory.check_book_existance?(book_isbn))
                inventory.remove_book(book_isbn)
                puts "***********book removed successfully, enter any key to continue"
                clr = gets.chomp
                clear_screen
            else
                puts "***********book not found, enter any key to continue"
                clr = gets.chomp
                clear_screen
            end
        when 4
            menu_flag = false
        else
            puts "wrong input please enter a valid number"
    end
end
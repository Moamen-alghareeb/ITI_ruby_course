require 'json'

def clear_screen
    system('cls') || system('clear') || puts("\e[H\e[2J")
end


class Inventory
    attr_accessor :books
    attr_reader :path
    def initialize
        @path = "library.json"
        if File.exist?(@path) && !File.zero?(@path)
            json_data = File.read(@path)
            @books = JSON.parse(json_data)
        else
            @books = {}
            save_books()  # Create the initial empty JSON file
        end
    end

    def add_book(title,author,isbn)
        if(check_book_existance?(isbn))
            @books[isbn]["Title"] = title
            @books[isbn]["Author"] = author
            @books[isbn]["count"] += 1
        else
            @books[isbn] = {:"Title" => title , :"Author" => author , :"Isbn" => isbn , :"count" => 1}
        end
        save_books()
    end

    def remove_book(isbn)
        if(@books[isbn]["count"] > 1)
            @books[isbn]["count"] -= 1
        else
            @books.delete(isbn)
        end
        save_books()
    end

    def check_book_existance?(isbn)
        @books.has_key?(isbn)
    end
    def display_books
        json_data = File.read(@path)
        @books = JSON.parse(json_data)
        if @books.size > 0
            @books.each {|key,value| puts "**********Book*******\nTitle: #{value["Title"]} \nAuthor:  #{value["Author"]} \nISBN: #{value["Isbn"]} \nCount: #{value["count"]}"}
        else
            puts "no books found"
        end
    end

    # save the books to the json file
    def save_books()
        books_json =  JSON.pretty_generate(@books)
        File.open(@path, "w") do |file|
            file.puts(books_json)
        end
    end
    # sort books by isbn and save the sorted books to the json file
    def sort_books()
        @books = (@books.sort_by {|key,value| key.to_i}).to_h
        display_books()
        save_books()
    end
    # search by title and display the book with that title (strict search not case sensitive or regex)
    def search_by_title(title)
        found = false
        @books.each_value {|value| if value["Title"] == title
            display_single_book(value)
            found = true
        end
        }
        puts "no book found" unless found
    end
    # search by author and display all books by that author (strict search not case sensitive or regex)
    def search_by_author(author)
        found = false
        @books.each_value {|value| if value["Author"] == author
            display_single_book(value)
            found = true
        end
        }
        puts "no book found" unless found
    end
    # search by isbn and display the book with that isbn
    def search_by_isbn(isbn)
        if @books.has_key?(isbn)
            display_single_book(@books[isbn])
        else
            puts "no book found"
        end
    end
    # Helper method to display a single book
    private
    def display_single_book(book)
            puts "**********Book*******\nTitle: #{book["Title"]} \nAuthor:  #{book["Author"]} \nISBN: #{book["Isbn"]} \nCount: #{book["count"]}"
    end
end
    inventory = Inventory.new

menu_flag = true
while menu_flag == true
    puts "***************** Menu ***************"
    puts "1-List books"
    puts "2-Add book"
    puts "3-remove book By ISBN"
    puts "4-sort book by ISBN"
    puts "5-search book by Title"
    puts "6-search book by Author"
    puts "7-search book by ISBN"
    puts "8-exit"

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
            inventory.sort_books()
            puts "***********books sorted successfully, enter any key to continue"
            clr = gets.chomp
            clear_screen
        when 5 
            puts "please enter book's title:"
            book_title = gets.chomp
            inventory.search_by_title(book_title)
            clr = gets.chomp
            clear_screen
        when 6
            puts "please enter book's author:"
            book_author = gets.chomp
            inventory.search_by_author(book_author)
            puts "***********enter any key to continue"
            clr = gets.chomp
            clear_screen
        when 7
            puts "please enter book's isbn:"
            book_isbn = gets.chomp
            inventory.search_by_isbn(book_isbn)
            puts "***********enter any key to continue"
            clr = gets.chomp
            clear_screen
        when 8
            menu_flag = false
        else
            puts "wrong input please enter a valid number"
    end
end
require_relative '../../config/environment'
require 'tty-prompt'
require 'pry'

class CLI
    @@user = ""
    def run
        puts "Welcome to the Hiking Trail review app!"
        prompt = TTY::Prompt.new
        option = prompt.select('Please select the following option', ["New user", "Login", "Exit"])
        if option == "New user"
            new_user
        elsif option == "Login"
            login
        else
            puts "Bye bye!"
            sleep(4)
        end
    end

    def new_user
        prompt = TTY::Prompt.new
        user_instance = prompt.ask("Enter your name")
        @@user = User.create(name: user_instance)
        commands
        # Transfer the follow up options
    end
    def login
        prompt = TTY::Prompt.new
        user_input = prompt.ask("Enter your username")
        user = User.all.find{|user| user.name == user_input}
        # binding.pry
        if user 
            puts "Welcome back #{user.name}"
            @@user = user 

            # transfer follow up options
            commands
        else 
            puts "That user does not exists"
            run
        end
    end
    def commands
        prompt = TTY::Prompt.new
        command = prompt.select("Please select the following:", ["See hiking trail locations", "Write a review", "See your reviews","Exit"])
        if command == "See hiking trail locations"
            hiking_trail_locations
        elsif 
            command == "Write a review"
            write_review
        elsif 
            command == "See your reviews"
            see_reviews
        else
            run
        end
    end

    def hiking_trail_locations
    end

    def write_review
    end

    def see_reviews
    end
end
# binding.pry

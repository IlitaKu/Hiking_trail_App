require_relative '../../config/environment'
require 'tty-prompt'
require 'pry'

class CLI
    @@prompt = TTY::Prompt.new
    @@user = ""
    def run
        puts "Welcome to the Hiking Trail review app!"
        option = @@prompt.select('Please select the following option', ["New user", "Login", "Exit"])
        if option == "New user"
            new_user
        elsif option == "Login"
            login
        else
            puts "Bye bye!"
            # sleep(4)
        end
    end

    def new_user
        user_instance = @@prompt.ask("Enter your name")
        @@user = User.create(name: user_instance)
        commands
        # Transfer the follow up options
    end
    def login
        user_input = @@prompt.ask("Enter your username")
        user = User.all.find{|user| user.name.upcase == user_input.upcase}
        # binding.pry
        if user 
            puts "Welcome back #{user.name}"
            @@user = user 

            # transfer follow up options
            commands
        else 
            @@prompt.say("This user does not exist")
            run
        end

        # binding.pry
    end
    def commands
        command = @@prompt.select("Please select the following:", ["See hiking trail locations", "Write a review", "See your reviews", "Update your reviews", "Delete your account", "Exit"])
        if command == "See hiking trail locations"
            hiking_trail_locations
        elsif 
            command == "Write a review"
            write_review
        elsif 
            command == "See your reviews"
            see_reviews
        elsif
            command == "Update your reviews"
            update_review
        elsif
            command == "Delete your account"
            delete_account
        else
            run
        end
    end

    def hiking_trail_locations
        @list = Hiking_Trail.all.map{|location| 
            # binding.pry
        p location.location}
        # binding.pry
        if @@prompt.yes?("Would you like to write a review?")
            write_review
        else
            commands 
        end
    end

    def write_review
        selected_place = @@prompt.select("Please select location to review:", @list)
        trail = Hiking_Trail.find_by(location: selected_place)
        content = @@prompt.ask("Tell us what you think about #{selected_place} trail", required: true)
        rating = @@prompt.ask("please rate your experience on a scale of 1 to 5", required: true)
        # Review.create(trail_id: trail.id, user_id: @@user.id, rating: rating, content: content)
        Review.create([{content: content, rating: rating, hiking_trail_id: trail.id, user_id: @@user.id}])
        # binding.pry
        commands 
    end

    def see_reviews

        @personal_reviews = Review.select{|review|review.user_id == @@user.id}
        
        @review_names = @personal_reviews.map{|review| review.content}
        @user_review = @@prompt.select("Here is all the reviews we got from you so far!", @review_names)
        commands
    end

    def update_review
        @personal_reviews = Review.select{|review|review.user_id == @@user.id}
        
        @review_names = @personal_reviews.map{|review| review.content}
        @content = @@prompt.select("Here is all the reviews we got from you so far!", @review_names)
        @selected_review = Review.find_by(content: @content)
        user_choice = @@prompt.select("What would you like to update?", ["content", "rating"])
        # updated_review = @@user.reviews.select{|content| content.content == @user_review}
        if user_choice == "content"

            new_content = @@prompt.ask("What is the new content?",required:true)
            @selected_review.update(content: new_content)
        end
    end
    def delete_account
        delete_account = @@prompt.ask("If you want to delete your account type 'DESTROY'")
        if delete_account == 'DESTROY'
            # binding.pry
        @@user.delete
        end
    end
end
# binding.pry

require_relative '../../config/environment'
require 'tty-prompt'
require 'pry'

class CLI
    @@prompt = TTY::Prompt.new(active_color: :cyan)
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
        commands
    end

    def new_user
        user_instance = @@prompt.ask("Enter your name", default: ENV['USER'])
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
            commands
        else 
            @@prompt.say("This user does not exist")
            run
        end

        # binding.pry
    end
    def commands
        command = @@prompt.select("Please select the following:", ["See hiking trail locations", "Read Hiking Trail reviews", "See your reviews", "Update your reviews", "Delete your account", "Delete review", "Exit"])
        if command == "See hiking trail locations"
            hiking_trail_locations
        elsif 
            command == "Read Hiking Trail reviews"
            see_reviews
        elsif 
            command == "See your reviews"
            see_personal_reviews
        elsif
            command == "Update your reviews"
            update_review
        elsif
            command == "Delete your account"
            delete_account
        elsif 
            command == "Delete review"
            delete_review
        else
            run
        end
    end

    def hiking_trail_locations
        @list = Hiking_Trail.all.map{|location| p location.location}
        if @@prompt.yes?("Would you like to write a review?")
            write_review
        else
            commands 
        end
    end

    def write_review
        selected_place = @@prompt.select("Please select location to review:", @list)
        trail = Hiking_Trail.find_by(location: selected_place)
        content = @@prompt.ask("Tell us what you think about #{selected_place} trail:", required: true)
        rating = @@prompt.ask("please rate your experience on a scale of 1 to 5:", required: true)
        @@prompt.say("Thank you for your participation!")
        Review.create([{content: content, rating: rating, hiking_trail_id: trail.id, user_id: @@user.id}])
        # binding.pry
        commands 
    end

    def see_personal_reviews
        @personal_review = Review.select{|review|review.user_id == @@user.id}.map{|review| review.content}
        if @personal_review.empty?
        @@prompt.say("You dont have reviews yet.")
        commands
        # binding.pry
        else
        user_reviews = @@prompt.select("Here is all the reviews we got from you so far:", @personal_review)
        commands
        end
    end

    def see_reviews
        all_trails = Hiking_Trail.all.map{|place| place.location}
        chosen_trail= @@prompt.select("Select the hiking trail to see reviews", all_trails)
        trail_object = Hiking_Trail.all.find_by(location: chosen_trail)
        selected_reviews = Review.all.select{|t| t.hiking_trail_id == trail_object.id}.map{|t| t.content}
        
        i = 0
        while selected_reviews.length > i do
            puts "Review #{i + 1}. #{selected_reviews[i]}"
            i += 1
        end
        commands
    end

    def update_review
        if @personal_review.empty?
            @@prompt.say("You dont have reviews yet.")
            commands
        end
        @personal_reviews = Review.select{|review|review.user_id == @@user.id}
        @review_names = @personal_reviews.map{|review| review.content}
        @content = @@prompt.select("Here is all the reviews we got from you so far!", @review_names)
        @selected_review = Review.find_by(content: @content)
        user_choice = @@prompt.select("What would you like to update?", ["content", "rating"])
        if user_choice == "content"
            new_content = @@prompt.ask("What is the new content?",required:true)
            @selected_review.update(content: new_content)
            @@prompt.say("Your review has been updated")
            commands
        elsif 
            user_choice == "rating"
            new_rating = @@prompt.ask("What is the new rating?",required:true)
            @selected_review.update(rating: new_rating)
        @@prompt.say("Your review has been updated")
        commands
    end
end

    def delete_account
        delete_account = @@prompt.yes?("Are you sure that you want to delete your account?", require: true)
        if delete_account 
        @@user.delete
        @@prompt.say("Your accout has been deleted.")
        run
        elsif
            @@prompt.say("Phew..that was close! Thank you for staying with us #{@@user.name.capitalize}!")
            commands
        end
    end
     def delete_review
        content = @@user.reviews.map {|t| t.content}
        deleted_content = @@prompt.select("Please select the review you would like to delete:", content)
        delete = @@prompt.yes?("Do you really want to delete this?", require: true)
        if delete == true
        review_to_delete = Review.all.find_by(content: deleted_content)
        review_to_delete.delete
        @@prompt.say("Your review has been deleted.")
        elsif
            @@prompt.say("Your review is safe with us!")
        end
        commands
     end
    end

# all user
# all review for each user

require_relative "../config/environment.rb"
require 'faker'

Hiking_Trail.destroy_all
User.destroy_all
Review.destroy_all
route1 = Hiking_Trail.create(location: "Everest")
route2 = Hiking_Trail.create(location: "Amazon")
route3 = Hiking_Trail.create(location: "Sahara")
user1 = User.create(name: "Mike")
user2 = User.create(name: "John")
user3 = User.create(name: "Sarah")
# Review.create(content:"Cold",rating: 5, hiking_trail_id: route1.id, user_id: user2.id)
# Review.create(content:"Hot",rating:1, hiking_trail_id: route2.id, user_id: user1.id)
# Review.create(content:"Wet",rating:4, hiking_trail_id: route1.id, user_id: user2.id)
# Review.create(content:"Not suitable for kids",rating: 2, hiking_trail_id: route3.id, user_id: user3.id)
# Review.create(content:"Amazing views",rating: 5, hiking_trail_id: route3.id, user_id: user1.id)
40.times.each do
    Review.create(content: Faker::Lorem.sentence(word_count: 4), rating: Faker::Number.within(range: 1..5), hiking_trail_id: Hiking_Trail.all.sample.id, user_id: user1.id )
end

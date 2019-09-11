class User < ActiveRecord::Base
    has_many :reviews
    has_many :hiking_trails, through: :reviews
    # def self.delete(name)
    #     self.find_by(name: name)
    #     self.destroy
    # end
end
    

class User < ActiveRecord::Base
	validates_presence_of :username, :email
	validates :username, uniqueness:  { message: "Sorry, that username is already taken" }
	validates :email, uniqueness: { message: "That email already has an account, did you mean to login?" }

	has_many :companies
	has_many :comments

	has_secure_password

  extend Slugger::ClassMethods

    def slug
      self.username.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') 
    end


    
end

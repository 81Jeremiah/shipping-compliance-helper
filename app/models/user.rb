class User < ActiveRecord::Base
	validates_presence_of :username, :email
	validates :username, uniqueness: true
	validates :email, uniqueness: true

	has_many :companies
	has_many :comments

	has_secure_password

  extend Slugger::ClassMethods

    def slug
      self.username.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') 
    end


    
end

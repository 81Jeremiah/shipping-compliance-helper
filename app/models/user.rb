class User < ActiveRecord::Base
	validates_presence_of :username, :email
	validates :username, uniqueness: true
	validates :email, uniqueness: true

	has_many :companies
	has_many :comments

	has_secure_password

	
    
    def slug
      self.username.split(" ").join("-").downcase
    end
    
    def self.find_by_slug(slug)
      self.all.find{|user| user.slug == slug}
    end
	
end
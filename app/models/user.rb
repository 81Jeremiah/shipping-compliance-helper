class User < ActiveRecord::Base
	has_many :companies
	has_many :comments

	has_secure_password

	validates_presence_of :username, :email
	validates :username, uniqueness: true
	validates :email, uniqueness: true

	
end
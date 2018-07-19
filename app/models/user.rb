class User < ActiveRecord::Base
	has_many :companies
	has_many :comments

	has_secure_password
	
end
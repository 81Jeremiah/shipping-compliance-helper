class User < ActiveRecord::Base
	validates_presence_of :username, :email
	validates :username, uniqueness: true
	validates :email, uniqueness: true

	has_many :companies
	has_many :comments

	has_secure_password

  include Slugger::InstanceMethods
  extend Slugger::ClassMethods

    
end

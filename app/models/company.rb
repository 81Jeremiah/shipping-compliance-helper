class Company < ActiveRecord::Base
	validates_presence_of :name
	validates :name, uniqueness: true

	belongs_to :user
	has_many :comments

	
end
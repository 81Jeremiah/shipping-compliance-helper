require_all 'app'

class Company < ActiveRecord::Base
	validates_presence_of :name
	validates :name, uniqueness: { message: "A company must have a name and can't already be in the database." }


	belongs_to :user
	has_many :comments
    
    extend Slugger::ClassMethods

    def slug
      self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    end
	
end
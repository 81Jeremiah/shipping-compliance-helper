class Comment < ActiveRecord::Base
    validates_presence_of :user_comment


	belongs_to :user
	belongs_to :company

	
end
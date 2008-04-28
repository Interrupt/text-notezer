class Note < ActiveRecord::Base
	validates_presence_of :note
	validates_numericality_of :user_id
	belongs_to :user
end

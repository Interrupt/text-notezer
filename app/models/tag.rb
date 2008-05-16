class Tag < ActiveRecord::Base
	validates_presence_of :text
	validates_numericality_of :user_id
	validates_numericality_of :note_id
	belongs_to :user
	belongs_to :note
end

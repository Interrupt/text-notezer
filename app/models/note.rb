class Note < ActiveRecord::Base
	validates_presence_of :note
	validates_numericality_of :user_id
	belongs_to :user
	belongs_to :notebook
	has_many :tagged_notes, :order => "id"
	has_many :tags, :through => :tagged_notes, :order => "id"
end

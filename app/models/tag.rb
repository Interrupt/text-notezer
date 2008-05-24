class Tag < ActiveRecord::Base
	validates_presence_of :text
	validates_numericality_of :user_id
	belongs_to :user
	belongs_to :note
	belongs_to :notebook
	has_many :tagged_notes, :order => "id"
	has_many :notes, :through => :tagged_notes, :order => "id"
end

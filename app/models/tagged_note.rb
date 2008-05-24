class TaggedNote < ActiveRecord::Base
	validates_presence_of :note_id
	validates_presence_of :tag_id
	belongs_to :note
	belongs_to :tag
end

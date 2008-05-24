class Notebook < ActiveRecord::Base
	validates_presence_of :name
	belongs_to :user
	has_many :notes, :order => "id"
	has_many :tags, :order => "id"
	
	def self.get_notes_by_tag(notebook, tag_text)
		found_notes = []
		
		if tag_text != 'unfiled'
			for note in notebook.notes
				for tag in note.tags
					found_notes.push note if tag.text == tag_text
				end
			end
		else
			for note in notebook.notes
				found_notes.push note if note.tags.count == 0
			end
		end
		
		return found_notes.reverse!
	end

end

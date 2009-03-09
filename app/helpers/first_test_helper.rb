module FirstTestHelper
	def getNoteText(note)
		text = CGI.escapeHTML(note.note)
		#Convert newlines to breaks
		text.gsub!("\n", "\n<br/>\n")
		#Turn html links into *real* html links
		text.gsub!(/(http|https):\/\/?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?.*)\s*/, '<a class="note_link" href="\0">\0</a>')
		return text
	end

	def getNoteEditHeight(note)
		height = note.note.count "\n"
		if height < 3 then
			height = 3	
		end
		return '46x' + height.to_s()
	end
	
	# eg: 2 years ago, 3 months ago, 4 days ago, 5 minutes ago
	def print_readable_date(date)
		time_ago_in_words(date)
	end
	
	def makeNotebookTagLink(notebook, tag)
		link = "<a href=\"?tag=#{tag.text}\">#{tag.text}</a>"
	end
end

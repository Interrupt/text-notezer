module FirstTestHelper
	def getNoteText(note)
		text = CGI.escapeHTML(note.note)
		#Convert newlines to breaks
		text.gsub!("\n", "\n<br/>\n")
		#Turn html links into *real* html links
		text.gsub!(/(http|https):\/\/?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?.*)\s*/, '<a class="note_link" href="\0">\0</a>')
		return text
	end
end

class Mailman < ActionMailer::Base
	def receive(email)
		from = email.from
		user = User.find_by_sms(from)
		user = User.find_by_email(from) if user == nil

		if user != nil
			notebook = Notebook.find_by_name_and_user_id("Unfiled Notes", user.id)
			
			#If the user does not have an unfiled notes notebook, make one
			if notebook == nil
				notebook = user.notebooks.create :name => "Unfiled Notes"
			end
			
			notebook.notes.create :note => remove_ending_whitespace(get_text_body(email)), :user_id => user.id
		else
			RAILS_DEFAULT_LOGGER.warn('Could not find user with that address')
		end
	end

	#Trim ending line breaks from the body, Gmail sends 3
	def remove_ending_whitespace(string)
		string = string.chomp
		string = string.chomp
		string = string.chomp
	end

	#Try to return text/plain over text/html bodies
	def get_text_body(mail)
		if mail.content_type == "multipart/alternative"
			body_text = ''
			body_html = ''

			mail.parts.each do |part|
				body_text += part.body if part.content_type == "text/plain"
				body_html += part.body if part.content_type == "text/html"
			end

			return body_text if body_text != ''
			return body_html
		end
		return mail.body	#Only one part, so just return the body
	end
end

class Mailman < ActionMailer::Base
	def receive(email)
		from = email.from
		user = User.find_by_sms(from)
		user = User.find_by_email(from) if user == nil

		if user != nil
			#user.notes.create :note => email.body
			user.notes.create :note => remove_ending_whitespace(get_text_body(email))
		end
	end

	def remove_ending_whitespace(string)
		string = string.chomp
		string = string.chomp
		string = string.chomp
	end

	#Try to return text/plain over text/html bodies
	def get_text_body(mail)
		body_text = ''
		body_html = ''

		mail.parts.each do |part|
			body_text += part.body if part.content_type == "text/plain"
			body_html += part.body if part.content_type == "text/html"
		end

		return body_text if body_text != ''
		return body_html
	end
end

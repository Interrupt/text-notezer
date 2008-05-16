class User < ActiveRecord::Base
	validates_presence_of :name
	validates_presence_of :password
	has_many :notes, :order => "id"

	def self.authenticate(user_info)
		find_by_name_and_password(user_info[:name], user_info[:password])
	end
end

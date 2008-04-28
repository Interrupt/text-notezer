class User < ActiveRecord::Base
	validates_presence_of :name
	validates_presence_of :password
	has_many :notes, :order => "id"
end

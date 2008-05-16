class Notebook < ActiveRecord::Base
	validates_presence_of :name
	belongs_to :user
	has_many :notes, :order => "id"
end

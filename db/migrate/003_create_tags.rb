class CreateTags < ActiveRecord::Migration
  def self.up
  	create_table :tags do |table|
  		table.column :text, :string
  		table.column :user_id, :integer
  		table.column :note_id, :integer
  	end
  end

  def self.down
  	drop_table :tags
  end
end

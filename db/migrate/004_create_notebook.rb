class CreateNotebook < ActiveRecord::Migration
  def self.up
 		create_table :notebooks do |table|
 			table.column :name, :string
 			table.column :user_id, :integer
 		end
 		
 		add_column :notes, :notebook_id, :integer
  end

  def self.down
  	drop_table :notebooks
  	remove_column :notes, :notebook_id
  end
end

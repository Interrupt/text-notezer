class CreateTaggedNotes < ActiveRecord::Migration
  def self.up
  	create_table :tagged_notes do |table|
 			table.column :note_id, :integer
 			table.column :tag_id, :integer
 		end
  end

  def self.down
  	drop_table :tagged_notes
  end
end

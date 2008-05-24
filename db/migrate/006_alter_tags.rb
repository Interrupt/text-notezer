class AlterTags < ActiveRecord::Migration
  def self.up
  	remove_column :tags, :note_id
  end

  def self.down
  	add_column :tags, :note_id
  end
end

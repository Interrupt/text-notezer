class AddNotebookIdToTag < ActiveRecord::Migration
  def self.up
	add_column :tags, :notebook_id, :integer
  end

  def self.down
	remove_column :tags, :notebook_id
  end
end

class AddAutoFields < ActiveRecord::Migration
  def self.up
	add_column :tags, :created_at, :datetime
	add_column :notes, :created_at, :datetime
	add_column :users, :created_at, :datetime
	add_column :notebooks, :created_at, :datetime

	add_column :tags, :updated_at, :datetime
        add_column :notes, :updated_at, :datetime
        add_column :users, :updated_at, :datetime
        add_column :notebooks, :updated_at, :datetime
  end

  def self.down
	remove_column :tags, :created_at
	remove_column :notes, :created_at
	remove_column :users, :created_at
	remove_column :notebooks, :created_at

	remove_column :tags, :updated_at
        remove_column :notes, :updated_at
        remove_column :users, :updated_at
        remove_column :notebooks, :updated_at
  end
end

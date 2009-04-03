class CreateHistories < ActiveRecord::Migration
  def self.up
    create_table :histories do |table|
      table.column :user_id, :integer
      table.column :type, :integer
      table.column :message, :string
      table.column :created_at, :datetime
      table.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :histories
  end
end

class Notes < ActiveRecord::Migration
  def self.up
  	create_table :notes do |table|
      table.column :note, :string
      table.column :user_id, :integer
    end	
  end

  def self.down
  	drop_table :notes
  end
end

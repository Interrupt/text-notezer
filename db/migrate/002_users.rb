class Users < ActiveRecord::Migration
  def self.up
  	create_table :users do |table|
      table.column :name, :string
      table.column :password, :string
    end	
  end

  def self.down
  	drop_table :users
  end
end

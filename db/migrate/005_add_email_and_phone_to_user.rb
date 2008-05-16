class AddEmailAndPhoneToUser < ActiveRecord::Migration
  def self.up
	add_column :users, :email, :string
	add_column :users, :sms, :string
  end

  def self.down
	drop_column :users, :email
	drop_column :users, :sms
  end
end

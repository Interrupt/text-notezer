class AddPublicToNotebooks < ActiveRecord::Migration
  def self.up
    add_column :notebooks, :shared_public, :boolean
    Notebook.reset_column_information
    Notebook.find(:all).each { |n| n.update_attribute :shared_public, false } 
  end

  def self.down
    remove_column :notebooks, :shared_public
  end
end

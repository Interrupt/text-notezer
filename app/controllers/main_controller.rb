class MainController < ApplicationController
  def index
    @notebooks = Notebook.find(:all,
      :conditions => "shared_public = true",
      :order => 'id DESC', :limit => 20)
    end
end

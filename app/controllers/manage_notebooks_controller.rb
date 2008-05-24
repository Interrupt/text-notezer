class ManageNotebooksController < ApplicationController
	before_filter :login_required, :only => :index
	
	def index
		@notebooks = @user.notebooks
	end
	
	def new_notebook
		@notebook = Notebook.new
		render :partial => "new_notebook_form", :locals => {:notebook => @notebook }
	end
	
	def add_notebook
		@notebook = Notebook.new(params[:notebook])
		@notebook.user_id = @user.id
		@notebook.save
		
		redirect_to :action => 'index'
	end
	
	def cancel_notebook
		render :partial => "new_notebook"
	end
end

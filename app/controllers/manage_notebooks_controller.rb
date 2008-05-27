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
	
	def cancel_edit_notebook
		notebook = Notebook.find(params[:notebook])
		render :partial => "notebook", :object => notebook
	end
	
	def submit_edit_notebook
		@notebook = Notebook.find(params[:notebook][:id])
		@notebook.name = params[:notebook][:name]
		@notebook.save

		session[:editing_notebook] = nil

		render :partial => 'notebook', :object => @notebook
	end
	
	def edit_notebook
		@notebook = Notebook.find(params[:notebook])

		#Only one notebook should display an edit form at one time.
		render :update do |page|
			#If we're already editing a notebook, cancel it
			if session[:editing_notebook] != nil
				@old_notebook = Notebook.find(session[:editing_notebook])
				page.replace_html "notebook_#{session[:editing_notebook]}", :partial => 'notebook', :object => @old_notebook
			end
			
			session[:editing_notebook] = params[:notebook]	#A notebook is being edited, store the id
			page.replace_html "notebook_#{params[:notebook]}", :partial => 'edit_notebook', :locals => {:notebook => @notebook}
		end
	end
	
	def delete_notebook
		@notebook = Notebook.find(params[:notebook])
		notebook_id = @notebook.id
		Notebook.delete(notebook_id)	

		render :update do |page|
			page.hide "notebook_#{notebook_id}"
		end
	end
end

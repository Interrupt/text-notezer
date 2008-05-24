class FirstTestController < ApplicationController
	before_filter :login_required, :only => :index
	#before_filter :login_required, :only => :tags
  
	def index
		session[:notebook] = nil
		
		#Get notes for notes list
		if params[:tag] == nil
			@notes = Note.find(:all,
				:conditions => "user_id = #{@user.id}",
				:order => 'id DESC')
		else
			#TODO: Refactor this, find also by user_id 
			@filter_tag = Tag.find_by_text(params[:tag])

			@notes = []
			for tagged in @filter_tag.tagged_notes
				@notes.push tagged.note
			end
		end
			
		@base_url = '/RailsProject/first_test'

		#Get tags for tags list
		@tags = @tag_array = Tag.find(:all, :select => 'distinct tags.text',
                        :conditions => ['user_id = ?', @user.id], :order => 'text ASC')
	end
	
	def notebook
		#If no notebook_name is supplied then go back to the main page
		if params[:id] == nil or params[:id] == ''
			redirect_to :action => 'index'
			return
		end
		
		notebook_name = CGI.unescape(params[:id])
		@tag_text = params[:tag]
		@notebook = Notebook.find_by_name(notebook_name)
		@base_url = '/RailsProject/first_test/notebook/' + notebook_name
		session[:notebook] = @notebook
		
		#init our notes and tags lists for later
		@notes = []
		@tags = []
		
		if @notebook != nil
			@tags = @notebook.tags
			if @tag_text == nil
				@notes = Note.find(:all, :conditions => ['notebook_id = ?', @notebook.id], :order => 'id DESC')
			else
				@notes = Notebook.get_notes_by_tag(@notebook, @tag_text)
			end
		else
			if notebook_name == 'unfiled'
				@notes = Note.find(:all, :conditions => ['notebook_id IS NULL AND user_id = ?',
					@user.id], :order => 'id DESC')
			end
		end
	end

	def tags
		session[:notebook] = nil
		#@notes_array = Note.find(:all,
                #        :conditions => "user_id = #{@user.id}",
                #        :order => 'id DESC')

		#TODO: Refactor this, find also by user_id 
		@filter_tag = Tag.find_by_text(params[:id])

		@notes = []
		for tagged in @filter_tag.tagged_notes
			@notes.push tagged.note
		end
		
		#for note in @notes_array
		#	added = false
		#	for tag in note.tags
		#		if tag.text == @filter_tag.text and added == false
		#			@notes.push note
		#			added = true
		#		end
		#	end
		#end

		#Get tags for tags list
		@tags = @tag_array = Tag.find(:all, :conditions => ['user_id = ?', @user.id], :order => 'text ASC')
	end

	def unfiled
		session[:notebook] = nil
		
		@notes_array = Note.find(:all,
			:conditions => "user_id = #{@user.id}",
			:order => 'id DESC')

		@notes = []
		for note in @notes_array
			if note.tagged_notes.length == 0
				@notes.push note
			end
		end

		#Get tags for tags list
		@tags = @tag_array = Tag.find(:all, :conditions => ['user_id = ?', @user.id], :order => 'text ASC')
	end
	
	# GET /tags_paginate/1
	def paginate
		#TODO: Currently not working: deprecated in Rails 2.0?
		@note_pages, @notes = paginate(:notes, :include => [:parent_item],
                            :conditions => ['user_id = ?', @user_id], 
                            :order         => 'id DESC', 
                            :per_page     => 20)
                            
		#Get tags for tags list
		@tags = @tag_array = Tag.find(:all, :conditions => ['user_id = ?', @user.id], :order => 'text ASC')
	end

	def new_note
		@note = Note.new
		@notebook = session[:notebook]
		render :partial => "new_note_form", :locals => {:note => @note, :notebook => @notebook }
	end

	def add_note
		@tags = params['tags_string'].split(' ')
		@notebook = session[:notebook]
			
		@note = add_note_to_notebook(params[:note], @tags, @notebook)
		make_note_tags(@note, @tags)

		if @notebook != nil
			redirect_to '/RailsProject/first_test/notebook/' + CGI.escape(@notebook.name)
		else
			redirect_to :action => 'index'
		end
	end
	
	def add_note_to_notebook(note_params, tags, notebook)
		@note = Note.new(note_params)
		@note.user_id = @user.id
		@note.notebook_id = notebook.id if notebook != nil
		@note.save
		return @note
	end
	
	def make_note_tags(note, tags)
		for tag in tags
			the_tag = Tag.find(:first, :conditions => ['notebook_id = ? AND text = ?', note.notebook.id, tag],
				:order => 'text ASC')
      if the_tag == nil
	      the_tag = Tag.create :text => tag, :user_id => @user.id, :notebook_id => note.notebook.id
      end
      TaggedNote.create :note_id => note.id, :tag_id => the_tag.id
		end
	end
	
	def edit_note
		@note = Note.find(params['id'])

		#Make the tags list for this note a string
		@tags = ''
		for tagged_note in @note.tagged_notes
			tag = tagged_note.tag
			@tags += (tag.text + ' ') if tag != nil
		end
		@tags = @tags.chop()
		
		render :partial => "edit_note_form", :locals => {:note => @note, :tag_string => @tags }
	end

	def update_note
		#Save the edited note
		@note = Note.find(params[:note][:id])
		@note.note = params[:note][:note]
		@note.save

		#Delete newly empty tags
		for tagged in @note.tagged_notes
			if tagged.tag != nil and tagged.tag.tagged_notes.length <= 1
				Tag.delete(tagged.tag.id)
			end
		end
		
		#Clear the tags list, we'll rebuild it after this
		TaggedNote.delete_all "note_id = #{@note.id}"
		
		#Parse the new tags string
		@tags = params['tags_string'].split(' ')
		
		#Recreate the note tags
		make_note_tags(@note, @tags)

		#Get an updated note object with the new tags	
		@note = Note.find(@note.id)	
		render :partial => "note", :locals => {:note => @note }
	end

	def cancel_edit_note
		@note = Note.find(params['id'])
		render :partial => "note", :locals => {:note => @note }
	end

	def cancel_note
		render :partial => "new_note"
	end

	def delete_note
		@notebook = session[:notebook]
		
		#Delete the note. Goodbye note!
		@note = Note.find(params['id'])

		#Delete newly empty tags
    for tagged in @note.tagged_notes
            if tagged.tag.tagged_notes.length <= 1
                    Tag.delete(tagged.tag.id)
            end
    end

		#Clear the tags list
		TaggedNote.delete_all "note_id = #{@note.id}"
		@note.destroy
		
		if @notebook != nil
			redirect_to '/RailsProject/first_test/notebook/' + CGI.escape(@notebook.name)
		else
			redirect_to :action => 'index'
		end
	end
end

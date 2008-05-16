class FirstTestController < ApplicationController
	before_filter :login_required, :only => :index
	#before_filter :login_required, :only => :tags
  
	def index
		#Get notes for notes list
		@notes = Note.find(:all,
			:conditions => "user_id = #{@user.id}",
			:order => 'id DESC')

		#Get tags for tags list
		@tags = @tag_array = Tag.find(:all, :select => 'distinct tags.text',
                        :conditions => ['user_id = ?', @user.id], :order => 'text ASC')
	end

	# GET /tags/1
	def tags
		@notes_array = Note.find(:all,
                        :conditions => "user_id = #{@user.id}",
                        :order => 'id DESC')

		#TODO: Refactor this, this is prototyping crap just to get this testable
		@filter_tag = Tag.find_by_text(params[:id])

		@notes = []
		for note in @notes_array
			added = false
			for tag in note.tags
				if tag.text == @filter_tag.text and added == false
					@notes.push note
					added = true
				end
			end
		end

    		#Get tags for tags list
    		@tags = @tag_array = Tag.find(:all, :select => 'distinct tags.text',
    			:conditions => ['user_id = ?', @user.id], :order => 'text ASC')
	end

        def unfiled
                @notes_array = Note.find(:all,
                        :conditions => "user_id = #{@user.id}",
                        :order => 'id DESC')

                @notes = []
                for note in @notes_array
			if note.tags.length == 0
	                        @notes.push note
                        end
                end

                #Get tags for tags list
                @tags = @tag_array = Tag.find(:all, :select => 'distinct tags.text',
                        :conditions => ['user_id = ?', @user.id], :order => 'text ASC')
        end
	
	# GET /tags_paginate/1
	def paginate
		#TODO: Currently not working: deprecated in Rails 2.0?
		@note_pages, @notes = paginate(:notes,
														:include     => [:parent_item],
                            :conditions => ['user_id = ?', @user_id], 
                            :order         => 'id DESC', 
                            :per_page     => 20)
                            
    #Get tags for tags list
    @tags = @tag_array = Tag.find(:all, :select => 'distinct tags.text',
    	:conditions => ['user_id = ?', @user.id], :order => 'text ASC')
	end

	def new_note
		@note = Note.new
		render :partial => "new_note_form", :locals => {:note => @note }
	end

	def add_note
		#Create and save the new note
		@note = Note.new(params[:note])
		@note.user_id = @user.id
		@note.save

		#Parse the new tags string
		@tags = params['tags_string'].split(' ')

		#Recreate the tags
		for tag in @tags
			Tag.create :text => tag, :user_id => @user.id, :note_id => @note.id
                end

		redirect_to :action => 'index'
	end

	def edit_note
		@note = Note.find(params['id'])

		#Make the tags list for this note a string
		@tags = ''
		for tag in @note.tags
			@tags += (tag.text + ' ')
		end
		@tags = @tags.chop()
		
		render :partial => "edit_note_form", :locals => {:note => @note, :tag_string => @tags }
	end

	def update_note
		#Save the edited note
		@note = Note.find(params[:note][:id])
		@note.note = params[:note][:note]
		@note.save
		
		#Clear the tags list, we'll rebuild it after this
		Tag.delete_all "note_id = #{@note.id}"
		
		#Parse the new tags string
		@tags = params['tags_string'].split(' ')
		
		#Recreate the tags
		for tag in @tags
			Tag.create :text => tag, :user_id => @user.id, :note_id => @note.id
		end
		
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
		#Delete the note. Goodbye note!
		@note = Note.find(params['id'])

		#Clear the tags list
                Tag.delete_all "note_id = #{@note.id}"

		@note.destroy
		redirect_to :action => 'index'
	end
end 

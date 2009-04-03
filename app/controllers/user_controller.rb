class UserController < ApplicationController
  def index
    redirect_to '/'
  end

  def view
    if params[:id] == nil or params[:id] == ''
      redirect_to '/'
    end
    
    @viewing = User.find_by_name( CGI.unescape(params[:id]) )
    if @viewing != nil
      @notes = Note.find(:all,
        :joins => "INNER JOIN notebooks ON notebooks.id=notes.notebook_id AND notebooks.shared_public=true",
        :conditions => { :user_id => @viewing.id },
        :limit => 15,
        :order => 'id DESC' )
    end
  end

  def notebook
    if params[:id] == nil or params[:id] == '' \
      or params[:notebook] == nil or params[:notebook] == ''
      redirect_to '/'
    end

    @viewing = User.find_by_name( CGI.unescape(params[:id]) )
    @notebook = Notebook.find(:first, :conditions => { :user_id => @viewing.id, :name => CGI.unescape(params[:notebook]) } )
    if @notebook != nil
      @notes = Note.find(:all,
        :joins => "INNER JOIN notebooks ON notebooks.id=#{ @notebook.id } AND notebooks.id=notes.notebook_id AND notebooks.shared_public=true",
        :conditions => { :user_id => @viewing.id },
        :limit => 15,
        :order => 'id DESC' )
    end
  end
end 

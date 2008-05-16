# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :set_user

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e34a9dfb5b252f6b3f267edf82a4d27c'

protected
  def set_user
    @user = User.find(session[:id]) if @user.nil? && session[:id]
  end

  def login_required
    return true if @user
    access_denied
    return false
  end

  #Check to see if the user is an admin before giving access
  def admin_required
  	if @user != nil
		return true if @user.name == 'chadc'
	end
	access_denied
	return false
  end
  
  def skip_if_logged_in
  	if @user
  		redirect_to :controller => 'first_test', :action => 'index'
  	end
  end

  def access_denied
    session[:return_to] = request.request_uri

    #Display message if they're linking to a deeper page than the index
    if session[:return_to] != '/RailsProject/'
    flash[:error] = 'Slow your roll! You need to login first to do that.'
    end

    redirect_to :controller => 'login', :action => 'index'
  end
end

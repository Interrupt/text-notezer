class LoginController < ApplicationController
	before_filter :login_required, :only => :my_account
	before_filter :skip_if_logged_in, :only => :index

    def index
      @user = User.new
      @user.name = params[:name]
    end

    def process_login
      if user = User.authenticate(params[:user])
        session[:id] = user.id # Remember the user's id during this session
        redirect_to session[:return_to] || '/first_test/'
      else
        flash[:error] = "Wow, that login didn't work at all. Want to try that again?"
        redirect_to :action => 'index', :name => params[:user][:name]
      end
    end

    def logout
      reset_session
      flash[:message] = 'Logged out.'
      redirect_to :controller => 'main', :action => 'index'
    end

    def my_account
    end
  end 

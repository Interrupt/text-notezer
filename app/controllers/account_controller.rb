class AccountController < ApplicationController
	before_filter :login_required, :only => :index

	def index
	end

	def update
		user = User.new(params[:user])
		changed = false;

		if user.password == params[:password_verify]
			if user.password != @user.password
				@user.password = user.password
				changed = true;
				flash[:notice] = 'Updated Password. You are going to remember this one, right?<br>'
			end
		else
			#Die, passwords do not match
			flash[:notice] = 'Passwords do not match.'
			redirect_to :action => 'index'
			return
		end

		if user.email != @user.email
			if (User.find_by_email user.email) == nil
				@user.email = user.email
				changed = true;

				flash[:notice] ||= ''
				flash[:notice] += 'Updated email address. Sent to Nigerian spammers.<br>'
			else
				#Die, not a unique email address
				flash[:notice] = 'Sorry, that email address is already in use.'
				redirect_to :action => 'index'
	                        return
			end
		end

		if user.sms != @user.sms
			if(User.find_by_sms user.sms) == nil
				@user.sms = user.sms
				changed = true

				flash[:notice] ||= ''
				flash[:notice] += 'Updated SMS address, ready your thumbs.'
			else
				#Die, not a unique sms address
				flash[:notice] = 'Sorry, that sms address is already in use.'
                                redirect_to :action => 'index'
                                return
			end
		end

		@user.save if changed
		
		redirect_to :action => 'index'	
	end
end

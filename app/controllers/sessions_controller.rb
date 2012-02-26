class SessionsController < ApplicationController
  skip_before_filter :require_login, :only => [:login, :logout]
  def login
    return unless request.post?
    @current_authuser = Authuser.authenticate(params[:login], params[:password])
    if @current_authuser
      session[:authuser] = @current_authuser.id
      
      if params[:remember_me] == "1"
        @current_authuser.remember_me
        cookies[:_daily_mugshot_auth_token] = { :value => @current_authuser.remember_token , :expires => 1.year.from_now } 
      end
      # redirect_to my_mugshow_url
      
      flash[:notice] = "Logged in successfully" 
    else
      flash[:notice] = "Incorrect Login" 
    end
    redirect_to root_path
  end
  
  def logout
    #remove remember me
    #delete cookie
    reset_session
    flash[:notice] = "You have been logged out."
    #this was redirect_to or back but that doesn't work anymore...add that to the to do list
    redirect_to root_path
  end
end

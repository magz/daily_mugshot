class SessionsController < ApplicationController
  def login
    return unless request.post?
    current_authuser = Authuser.authenticate(params[:login], params[:password])
    if current_authuser
      session[:authuser] = current_authuser.id
      #leaving remember me off for now so i don't have to deal with cookies
      # if params[:remember_me] == "1"
      #   self.current_authuser.remember_me
      #   cookies[:_daily_mugshot_auth_token] = { :value => self.current_authuser.remember_token , :expires => 1.year.from_now } 
      # end
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

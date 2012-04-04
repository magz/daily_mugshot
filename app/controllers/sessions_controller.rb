class SessionsController < ApplicationController
  skip_before_filter :require_login, :only => [:login, :logout]
  def login
    return unless request.post?
    if Authuser.find_by_login(params[:login])
      @current_authuser = Authuser.authenticate(params[:login], params[:password])
    else 
      if Authuser.find_by_email(params[:login])
        @current_authuser = Authuser.authenticate(Authuser.find_by_email(params[:login]).login, params[:password])
      end
    end
    if @current_authuser
      @current_authuser.delay.try_image_all
      session[:authuser] = @current_authuser.id
      
      if params[:remember_me] == "1"
        @current_authuser.remember_me
        cookies[:_daily_mugshot_auth_token] = { :value => @current_authuser.remember_token , :expires => 1.year.from_now } 
      end
      # redirect_to my_mugshow_url
      if @current_authuser.consistency == nil
        #temporary to ensure user_stats get populated
        begin
          @current_authuser.save
        rescue
        end
      end
      flash[:notice] = "Logged in successfully"
      if current_authuser.already_taken_today?
        redirect_to "/authusers/" + current_authuser.id.to_s
      else
        redirect_to :new_pic
      end
       
    else
      flash[:notice] = "Incorrect Login" 
      redirect_to :root
      
    end
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

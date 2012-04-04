class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_login
  #before_filter :login_from_cookie
  #before_filter :maintenance
  # Returns true or false if the user is logged in.
  # Preloads @current_authuser with the user model if they're logged in.
  
  def logged_in?
    current_authuser
  end
  
  def current_authuser
    @current_authuser ||= Authuser.find_by_id(session[:authuser])
  end
  
  def current_authuser=(new_authuser)
    session[:authuser] = (new_authuser.nil? || new_authuser.is_a?(Symbol)) ? nil : new_authuser.id
    @current_authuser = new_authuser
  end
  
  # def login_from_cookie
  #   return unless cookies[:_daily_mugshot_auth_token] && !logged_in?
  #   user = Authuser.find_by_remember_token(cookies[:_daily_mugshot_auth_token])
  #   if user && user.remember_token?
  #     user.remember_me
  #     cookies[:_daily_mugshot_auth_token] = { :value => user.remember_token , :expires => user.remember_token_expires_at }
  #     flash[:notice] = "Logged in successfully"
  #   end
  # end
  
  def require_login
    unless current_authuser
      flash[:notice] = "You must be logged in to access this section"
      redirect_to :root
    end
  end

  def require_admin
    unless current_authuser && (current_authuser.id == 1 || current_authuser.id == 60581)
      flash[:notice] = "Admin area only"
      redirect_to :root 
    end
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :login_from_cookie, :require_login
  
  # Returns true or false if the user is logged in.
  # Preloads @current_authuser with the user model if they're logged in.
  def logged_in?
    current_authuser
  end
  
  def current_authuser
    begin
      Authuser.find_by_id(session[:authuser])
    rescue
      false
    end
  end
  
  def login_from_cookie
    return unless cookies[:_daily_mugshot_auth_token] && !logged_in?
    user = Authuser.find_by_remember_token(cookies[:_daily_mugshot_auth_token])
    if user && user.remember_token?
      user.remember_me
      cookies[:_daily_mugshot_auth_token] = { :value => user.remember_token , :expires => user.remember_token_expires_at }
      flash[:notice] = "Logged in successfully"
    end
  end
  
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

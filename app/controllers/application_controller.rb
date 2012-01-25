class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Returns true or false if the user is logged in.
  # Preloads @current_authuser with the user model if they're logged in.
  def logged_in?
    current_authuser
  end
  
  def current_authuser
    @current_authuser ||= Authuser.find_by_id(session[:authuser])
  end
  
end

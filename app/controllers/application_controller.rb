class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_authuser
    @current_authuser ||= Authuser.find_by_id(session[:authuser])
  end
  
end

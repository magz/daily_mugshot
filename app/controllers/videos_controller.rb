require "uri"
require 'net/http'

class VideoController < ApplicationController

  before_filter :login_required
  
  def create
    
    
    
    video = Video.new()
    video.authuser_id = current_authuser.id
    video.save!
    begin
      address = video.generate_self
      flash[:notice] = "Your video has been successfully created!  Check it out on our youtube channel soon (it may take a few minutes to be processed by Google) <a href=#{address}>HERE</a>"
    rescue
      flash[:notice] = "Something went wrong with the creation of your video.  We're working to improve this new feature, so please send us feedback letting us know"
    end
    
    redirect_to :root
     
  end

  def new
    @authuser = current_authuser
   
  end
  
  
  def test
    
  end


end

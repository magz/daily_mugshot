class MainController < ApplicationController
  skip_before_filter :require_login, :only => [:welcome, :faq, :about]
  def welcome
    @mugshots = Mugshot.where("image_file_name != 'nil'").last 6
    
  end
  
  def faq
  
  end
  
  def about
    
  end
  
  def get_reminder
  
  end
  
  def publish
    client = TwitterOAuth::Client.new(
        :consumer_key => 'CMeT41r3DM1cKvQMTZQ1RA',
        :consumer_secret => 'wjZcmfEsJTcoUfJaU47Hnloj9o7LgzBejlOECYAs'
    )
    @request_token = client.request_token(:oauth_callback => "http://localhost:3000/twitter_connect/callback")
    
  end
  
end

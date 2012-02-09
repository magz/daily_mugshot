class PublishController < ApplicationController
  
  def new
    twitter_client = TwitterOAuth::Client.new(
        :consumer_key => 'CMeT41r3DM1cKvQMTZQ1RA',
        :consumer_secret => 'wjZcmfEsJTcoUfJaU47Hnloj9o7LgzBejlOECYAs'
    )
    @twitter_request_token = twitter_client.request_token(:oauth_callback => "http://localhost:3000/publish/twitter_callback")
    session[:twitter_request_token] = @twitter_request_token
    @fb_client = Koala::Facebook::OAuth.new
    
  end
  
  def twitter_callback
    unless current_authuser.twittering?
      begin
          twitter_client = TwitterOAuth::Client.new(
              :consumer_key => 'CMeT41r3DM1cKvQMTZQ1RA',
              :consumer_secret => 'wjZcmfEsJTcoUfJaU47Hnloj9o7LgzBejlOECYAs'
          )
      
          access_token = twitter_client.authorize(
            session[:twitter_request_token].token,
            session[:twitter_request_token].secret,
            :oauth_verifier => params[:oauth_verifier]
          )
          flash[:notice] = access_token.inspect
          new_twitter_connect = TwitterConnect.new
          new_twitter_connect.authuser_id = current_authuser
          new_twitter_connect.secret = access_token.secret
          new_twitter_connect.token = access_token.token
          new_twitter_connect.save
        flash[:notice] = "You have successfully added twitter"
      rescue
        flash[:notice] = "Something went wrong, please try again"
        
      end
    else
        flash[:notice] = "You're already tweeting"
      end
      redirect_to :root
  end
  
  def facebook_callback
    
  end
end

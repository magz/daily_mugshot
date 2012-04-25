class TwitterConnectsController < ApplicationController
  
  def signup_for_twittter
    t = TwitterConnect.find_by_authuser_id(current_authuser.id)
    if t && t.active
        flash[:notice] = "You're already signed up for twitter!"
        redirect_to :root
    else if t && t.active == false
      t.active = true
      t.save
      flash[:notice] = "Your mugshtos will now be automatically tweeted!"
      redirect_to :root
      else
        redirect_to "/auth/twitter"
      end
    end


  end

  def deactivate_twitter
    t = TwitterConnect.find_by_authuser_id(current_authuser.id)
    if t
      t.active = false
      flash[:notice] = "Your mugshots will no longer be authomatically tweeted"
      t.save
    else
      flash[:notice] = "You are not curerntly signed up to have your mugshots automatically tweeted"
    end

    redirect_to :root

  end



  def create
    
    @credentials = request.env['omniauth.auth'].to_hash["credentials"]
    @access_token = prepare_access_token(@credentials["token"], @credentials["secret"])
    
    t=TwitterConnect.new(authuser_id: session[:authuser], token: @access_token.token, 
      secret: @access_token.secret, active: true)
    if t.save
      flash[:notice] = "You've successfully added twitter to Daily Mugshot.  We will automatically tweet each picture you take"
    else 
      flash[:notice] = "We're sorry there was something wrong with your twitter registration.  Please make sure your username and password were entered correctly and try again"
    end
    redirect_to :root
  end

  protected

  #lifted from stack overflow, hence the different gem etc
  #OAuth is required by twitter auth anyway, so nbd
  def prepare_access_token(oauth_token, oauth_token_secret)
    #generate consumer token
    consumer = OAuth::Consumer.new("2Tp53hDcEtkxel1DYxOQsQ", "i6Qqt1iBbV6tbv3TsaCzM3JmKJppnKDviNoHP6W0",
    {
        :site => "http://api.twitter.com"
    })
    # now create the access token object from passed values
    token_hash =
    {
      :oauth_token => oauth_token,
      :oauth_token_secret => oauth_token_secret
    }
    #create access token
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
    return access_token
  end

  # def auth_hash
  #   request.env['omniauth.auth']
  # end

  def failure
    flash[:notice] = "We're sorry there was something wrong with your twitter registration.  Please make sure your username and password were entered correctly and try again"
    redirect_to :root
  end


end
irect_to :root
  end


end

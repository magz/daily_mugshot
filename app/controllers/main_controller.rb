class MainController < ApplicationController
  skip_before_filter :require_login, :only => [:welcome, :faq, :about, :secret]
  #respond_to :js, :html, :xml, :json
  
  
  def welcome
    @mugshots = Mugshot.last(50).shuffle[1..6]
  end
  
  def faq
  
  end
  
  def about
    
  end
  
  def get_reminder
  
  end
  
  def camera_hope

  end
  def publish
    client = TwitterOAuth::Client.new(
        :consumer_key => 'CMeT41r3DM1cKvQMTZQ1RA',
        :consumer_secret => 'wjZcmfEsJTcoUfJaU47Hnloj9o7LgzBejlOECYAs'
    )
    @request_token = client.request_token(:oauth_callback => "http://localhost:3000/twitter_connect/callback")
    
  end
  
  def secret
   	@dino_comix=(Hash.from_xml open("http://www.rsspect.com/rss/qwantz.xml").read)["rss"]["channel"]["item"][0]["description"].html_safe
	
  end
  
  def martin_delete
    Authuser.find_by_login("trivialelement").mugshots.last.delete
    flash[:notice] = "successfully deleted chris martin"
    redirect_to :root
  end
  def pablo_delete
    Authuser.find_by_login("pabs616").mugshots.last.delete
    flash[:notice] = "successfully deleted pabloooooo"
    redirect_to :root
  end
  
  def create_video
    #for some reason putting this in the video controller makes flash[:notice] not work, so i'm putting it here until i figure out why
    video = Video.new()
    video.authuser_id = current_authuser.id
    video.save!
    begin
      address = video.generate_self
      flash[:notice] = "Your video has been successfully created! Check it out on our youtube channel soon (it may take a few minutes to be processed by Google) #{address}"
    rescue
      flash[:notice] = "Something went wrong with the creation of your video.  We're working to improve this new feature, so please send us feedback letting us know"
    end
    
    redirect_to :root
  end
end
aw_info["first_name"].to_s + raw_info["last_name"][0].to_s + rand(1000).to_s
            unless Authuser.find_by_email(raw_info["email"]) 
              @authuser.email = raw_info["email"]
            else
              flash[:notice] = "Sorry, that email address is already taken.  If you would like to add facebook authentication to an existing account, please go to Update Account"
              redirect_to :root
              return
            end
            @authuser.time_zone = "Eastern Time (US & Canada)"
            @authuser.prvt = false
            @authuser.fb_id = raw_info["id"] 
      
            @authuser.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{@authuser.login}--")
            new_password = (0..8).map{ rand(36).to_s(36) }.join
            @authuser.crypted_password =  Authuser.encrypt(new_password, @authuser.salt)
            #uff problem here....need to add this to the update page
            @authuser.gender = "m"
            if @authuser.save
              session[:authuser] = @authuser.id
              session[:fb_login] = true
              UserMailer.forgot_password(@authuser, new_password).deliver
              flash[:notice] = "You've successfully registered for Daily Mugshot using Facebook!  You can login using Facebook OR your email address. If you need to change any of your account details, please do so below."
              redirect_to :my_account
        
            else
              flash[:notice] = "Sorry, but there was a problem with your Facebook registration.  You can try again, or register using your email address"
              redirect_to :root
            end
          else
            @authuser = Authuser.find_by_email(raw_info["email"])
            @authuser.fb_id = raw_info["id"] 
            if @authuser.save
              session[:authuser] = @authuser.id
              session[:fb_login] = true
              
              flash[:notice] = "Facebook login has been added to your existing account, #{@authuser.login}!  You can now login to Daily Mugshot using Facebook!"
              redirect_to :root
            else
              flash[:notice] = "Something went wrong adding facebook to your account"
              redirect_to :root
              
            end
          end
        else
          begin
            @authuser = current_authuser
            @authuser.fb_id = raw_info["id"] 
            @authuser.save
            flash[:notice] = "Facebook authorization has been added to your account!  You may now login via Facebook!"
            redirect_to :root
          rescue
            flash[:notice] = "Sorry, something went wrong adding Facebook authorization to your account."
            redirect_to :root
          end
        end
      end
    else
      flash[:notice] = "Sorry, but something went wrong with Facebook authentication."
      redirect_to :root
    end 
    
    
    logger.info request.env["omniauth.auth"].class
    request.env["omniauth.auth"].each do |k,v|
      logger.info k
      logger.info v
      logger.info "0000000000"
    end
    
    
    
    
    logger.info "9999999999"
    logger.info request.env["omniauth.auth"]["extra"]["raw_info"]["id"]
    logger.info "above should be your id"
    # @auth_hash = {}
    # request.env["omniauth.auth"].each do |k,v|
    #   @auto_hash.update(k => v)
    # end
    
  end  

  def martin_delete
    Authuser.find_by_login("trivialelement").mugshots.last.delete
    flash[:notice] = "successfully deleted chris martin"
    redirect_to :root
  end
  def pablo_delete
    Authuser.find_by_login("pabs616").mugshots.last.delete
    flash[:notice] = "successfully deleted pabloooooo"
    redirect_to :root
  end
  
  def create_video
    #for some reason putting this in the video controller makes flash[:notice] not work, so i'm putting it here until i figure out why
    video = Video.new()
    video.authuser_id = current_authuser.id
    video.save!
    begin
      address = video.generate_self
      flash[:notice] = "Your video has been successfully created! Check it out on our youtube channel soon (it may take a few minutes to be processed by Google) #{address}"
    rescue
      flash[:notice] = "Something went wrong with the creation of your video.  We're working to improve this new feature, so please send us feedback letting us know"
    end
    
    redirect_to :root
  end
end

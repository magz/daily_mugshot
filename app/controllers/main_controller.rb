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

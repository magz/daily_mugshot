class MainController < ApplicationController
  skip_before_filter :require_login, :only => [:welcome, :faq, :about, :secret]
  def welcome
    @mugshots = Mugshot.where("authuser_id != 65417").last 6
    logger.info "welcome to main page"
    logger.info session
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
    if params[:userid]
      @mugshots = Mugshot.where(authuser_id: params[:userid])
    else
      @mugshots = []
    end
    f= AWS::S3.new.buckets[:dailymugshotprod]
    @result_urls = []
    @mugshots.each do |m|
      if m.image.to_s.match("missing").class != NilClass
        if f.objects[m.filename].acl.grants.last.permission.to_s == "<Permission>READ</Permission>"
          @result_urls << "http://dqnxa4ugjb67h.cloudfront.net/" + m.filename
        else
          m.try_image
          @result_urls << m.image
        end
      else
        @result_urls << m.image
      end
    end
  end
  
  def martin_delete
    Authuser.find_by_login("trivialelement").mugshots.last.delete
    flash[:notice] = "successfully deleted chris martin"
    redirect_to :root
  end
end

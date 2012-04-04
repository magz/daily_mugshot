class TwitterConnect < ActiveRecord::Base
  TWITTER_CONSUMER_KEY = "2Tp53hDcEtkxel1DYxOQsQ"
  TWITTER_CONSUMER_SECRET = "i6Qqt1iBbV6tbv3TsaCzM3JmKJppnKDviNoHP6W0"


  belongs_to :authuser
  validates :authuser_id, :uniqueness => true  
  validates :token, :presence => true
  validates :secret, :presence => true

  def default_values
    self.active ||= true
  end 
    
  #validates :check_key_works
  
  def tweet(message)
    if self.active
      twitter_client = TwitterOAuth::Client.new(
          :consumer_key => TWITTER_CONSUMER_KEY,
          :consumer_secret => TWITTER_CONSUMER_SECRET,
          :token => self.token,
          :secret => self.secret
      )
      #does this do anything?
      if twitter_client.authorized?
        twitter_client.update(message)
      else
        self.active = false
        self.save
        #flash[:notice] = "If you would like to automatically tweet your mugshots, please go to you account options to reauthorize Daily Mugshot's twitter access"
      end
    end
  end
  
end

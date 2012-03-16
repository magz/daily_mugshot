class TwitterConnect < ActiveRecord::Base
  TWITTER_CONSUMER_KEY = "eUwxnXFyOEuo4pWx9WCw"
  TWITTER_CONSUMER_SECRET = "BuXKrX2vlkKaFZLU5k1XibuIxM85cahid6oFPNco"


  belongs_to :authuser
  validates :authuser_id, :uniqueness => true  
  validates :token, :presence => true
  validates :secret, :presence => true

  def default_values
    self.active ||= true
  end 
    
  #validates :check_key_works
  
  def tweet(message)
    if active
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
        flash[:notice] = "If you would like to automatically tweet your mugshots, please go to you account options to reauthorize Daily Mugshot's twitter access"
      end
    end
  end
  
end

class TwitterConnect < ActiveRecord::Base
  belongs_to :authuser
  before_create :default_values
  
  def default_values
    self.active ||= true
  end 
    
  #validates :check_key_works
  
  def tweet(message)
    twitter_client = TwitterOAuth::Client.new(
        :consumer_key => 'CMeT41r3DM1cKvQMTZQ1RA',
        :consumer_secret => 'wjZcmfEsJTcoUfJaU47Hnloj9o7LgzBejlOECYAs',
        :token => self.token, 
        :secret => self.secret
    )
    
    #does this do anything?
    twitter_client.authorized?
    
    twitter_client.update(message)
  end
  
end

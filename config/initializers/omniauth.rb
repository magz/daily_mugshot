TWITTER_CONSUMER_KEY = "eUwxnXFyOEuo4pWx9WCw"
TWITTER_CONSUMER_SECRET = "BuXKrX2vlkKaFZLU5k1XibuIxM85cahid6oFPNco"


Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "eUwxnXFyOEuo4pWx9WCw", "BuXKrX2vlkKaFZLU5k1XibuIxM85cahid6oFPNco" 
  provider :facebook, "ea22540703e80b87e46f5def91047927", "4cc6971fc2174281210ccc94c5aceb59", :scope => 'email,offline_access,read_stream', :display => 'popup'
end



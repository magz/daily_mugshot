# TWITTER_CONSUMER_KEY = "2Tp53hDcEtkxel1DYxOQsQ"
# TWITTER_CONSUMER_SECRET = "i6Qqt1iBbV6tbv3TsaCzM3JmKJppnKDviNoHP6W0"
# 
# 
# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :twitter, "2Tp53hDcEtkxel1DYxOQsQ", "i6Qqt1iBbV6tbv3TsaCzM3JmKJppnKDviNoHP6W0" 
#   provider :facebook, "ea22540703e80b87e46f5def91047927", "4cc6971fc2174281210ccc94c5aceb59", :scope => 'email,offline_access,read_stream', :display => 'popup'
# end
# 
# 
lay => 'popup'
# end
# 
# 
ENV["FACEBOOK_KEY"] = "190735387714811"
ENV['FACEBOOK_SECRET'] = "5923dfc003108c41dc80341be626155f"
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], {:scope => 'publish_stream,offline_access,email'}
end

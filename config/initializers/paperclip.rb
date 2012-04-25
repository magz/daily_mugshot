PAPERCLIP_CONFIG = {}
PAPERCLIP_CONFIG.merge!({
  :storage => :s3,
  :s3_credentials => Rails.root.join("config/amazon_s3.yml"),
  :path => ":class/:attachment/:id/:style_:basename.:extension",
  :bucket => 'rails3_production'
}) unless Rails.env.test?'
}) unless Rails.env.test?

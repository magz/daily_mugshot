class Mugshot < ActiveRecord::Base
  belongs_to :authuser
  has_many :comments
  validates :authuser, :presence => true
  # has_attached_file :image, PAPERCLIP_CONFIG.merge({
  #   :styles => {:full => "400x400", :inner => "200x200", :thumb => "50x50"},
  #   :processors => [:cropper]
  # })
  #cropper is a custom processor
  #it takes in the xoffset and yoffset and does cropping accordingly
  
  #i think this is set up correctly but double check it
  has_attached_file :image, :styles => {:full => "400x400", :inner => "200x200", :thumb => "50x50"}, :processors => [:cropper] 
  #:storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml", :bucket => "rails3_development" 
  
  
  
  
  
end

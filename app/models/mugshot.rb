class Mugshot < ActiveRecord::Base
  belongs_to :authuser
  has_many :comments
  
  # has_attached_file :image, PAPERCLIP_CONFIG.merge({
  #   :styles => {:full => "400x400", :inner => "200x200", :thumb => "50x50"},
  #   :processors => [:cropper]
  # })
  has_attached_file :image, :styles => {:full => "400x400", :inner => "200x200", :thumb => "50x50"}, :processors => [:cropper]
  
  
end

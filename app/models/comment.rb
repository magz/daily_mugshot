class Comment < ActiveRecord::Base
  belongs_to :authuser
  belongs_to :mugshot
  validates :authuser, :mugshot, :presence => true
  
end

class Friendship < ActiveRecord::Base
  belongs_to :authuser
  belongs_to :friend, :class_name => "Authuser"
  
end

class Friendship < ActiveRecord::Base
  belongs_to :authuser
  belongs_to :followee, :class_name => "Authuser"
  
end
_name => "Authuser"
  
end

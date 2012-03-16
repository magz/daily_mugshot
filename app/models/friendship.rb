class Friendship < ActiveRecord::Base
  belongs_to :authuser
  belongs_to :followee, :class_name => "Authuser"
  #validates :authuser, :uniqueness => { :scope => :followee, :message => "You're already friends with person" }
end

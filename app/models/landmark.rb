class Landmark < ActiveRecord::Base
  belongs_to :authuser
  validates :authuser, :xcoord, :ycoord, :presence => true
end

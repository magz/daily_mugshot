class Feedback < ActiveRecord::Base
  validates :body, :presence => true
end

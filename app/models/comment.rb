class Comment < ActiveRecord::Base
  belongs_to :authuser
  belongs_to :mugshot
end

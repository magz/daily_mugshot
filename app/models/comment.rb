class Comment < ActiveRecord::Base
  belongs_to :authuser
  belongs_to :owner, :class_name => "Authuser", :foreign_key => "owner_id"
  # validates :authuser, :mugshot, :presence => true
  before_save :set_init_vals
  
  def set_init_vals
      self.body ||= ""
  end
end

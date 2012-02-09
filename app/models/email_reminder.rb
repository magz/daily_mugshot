class EmailReminder < ActiveRecord::Base
  belongs_to :authuser
end

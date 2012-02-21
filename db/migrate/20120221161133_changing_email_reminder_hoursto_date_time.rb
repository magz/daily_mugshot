class ChangingEmailReminderHourstoDateTime < ActiveRecord::Migration
  def up
    change_column :email_reminders, :hour, :datetime
  end

  def down
    change_column :email_reminders, :hour, :integer
    
  end
end

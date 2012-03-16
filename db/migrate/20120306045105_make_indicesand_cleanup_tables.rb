class MakeIndicesandCleanupTables < ActiveRecord::Migration
  def up
    add_index :authusers, :time_zone 
    add_index :comments, :authuser_id 
    add_index :email_reminders, :hour 
    add_index :friendships, :authuser_id 
    add_index :friendships, :followee_id 
    add_index :landmarks, :authuser_id
    drop_table :old_mugshots
  end

  def down
    remove_index :authusers, :time_zone 
    remove_index :comments, :authuser_id 
    remove_index :email_reminders, :hour 
    remove_index :friendships, :authuser_id 
    remove_index :friendships, :followee_id 
    remove_index :landmarks, :authuser_id
    
  end
end

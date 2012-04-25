class CreateEmailReminders < ActiveRecord::Migration
  def change
    create_table :email_reminders do |t|
      t.integer :authuser_id
      t.integer :hour
      t.boolean :active
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
mestamps
    end
  end
end

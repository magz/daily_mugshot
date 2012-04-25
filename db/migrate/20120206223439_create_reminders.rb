class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :authuser_id
      t.string :platform
      t.string :version
      t.string :release_notes

      t.timestamps
    end
  end
end
mestamps
    end
  end
end

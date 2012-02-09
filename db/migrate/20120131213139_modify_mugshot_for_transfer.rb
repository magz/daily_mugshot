class ModifyMugshotForTransfer < ActiveRecord::Migration
  def up
    remove_column :mugshots, :active
    remove_column :mugshots, :old_image_url
    remove_column :mugshots, :deleted
  end

  def down
    change_table :mugshots do |t|
      t.boolean :active
      t.string :old_image_url
      t.boolean :deleted
    
    end
  end
end

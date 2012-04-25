class AddDeletedAtToMugshots < ActiveRecord::Migration
  def up
    change_table :mugshots do |t|
      t.datetime :deleted_at
      
    end
  end

  def down
    remove_column :mugshots, :deleted_at
    
  end
end
:deleted_at
    
  end
end

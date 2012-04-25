class AddDeletedAttoAuthuser < ActiveRecord::Migration
  def up
    change_table :authusers do |t|
      t.datetime :deleted_at
      
    end
  end

  def down
    remove_column :authusers, :deleted_at
    
  end
end
:deleted_at
    
  end
end

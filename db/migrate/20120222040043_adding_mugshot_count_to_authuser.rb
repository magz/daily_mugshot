class AddingMugshotCountToAuthuser < ActiveRecord::Migration
  def up
    change_table :authusers do |t|
      t.integer :mugshot_count

    end
  end

  def down
    remove_column :authusers, :mugshot_count
    
  end
end
gshot_count
    
  end
end

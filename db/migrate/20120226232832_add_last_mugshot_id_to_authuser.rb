class AddLastMugshotIdToAuthuser < ActiveRecord::Migration
  def up
    change_table :authusers do |t|
      t.integer :last_mugshot

    end
  end

  def down
    remove_column :authusers, :last_mugshot
  end
end
s, :last_mugshot
  end
end

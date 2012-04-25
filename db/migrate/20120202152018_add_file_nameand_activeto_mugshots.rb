class AddFileNameandActivetoMugshots < ActiveRecord::Migration
  def up
    change_table :mugshots do |t|
      t.string :filename

    end
  end

  def down
    remove_column :mugshots, :filename
    
  end
end
, :filename
    
  end
end

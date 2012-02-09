class AddSalttoAuthuser < ActiveRecord::Migration
  def up
    change_table :authusers do |t|
      t.string :salt
    end
  end

  def down
    remove_column :authusers, :salt
    
  end
end

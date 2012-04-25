class CreateAddSomeFieldstoAuthusers < ActiveRecord::Migration
  def up
    change_table :authusers do |t|
      t.string :remember_token
      t.datetime :remember_token_expires_at
      
    end
  end

  def down
    remove_column :authusers, :remember_token
    remove_colum :authusers, :remember_token_expires_at
    
  end
end
_expires_at
    
  end
end

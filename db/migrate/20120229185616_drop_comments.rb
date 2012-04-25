class DropComments < ActiveRecord::Migration
  def up
    # drop_table :comments
    create_table :comments do |t|
      t.integer :authuser_id
      t.integer :owner_id
      t.text :body
    
      t.timestamps
    end
  end

  def down
    drop_table :comments
  end
end
_table :comments
  end
end

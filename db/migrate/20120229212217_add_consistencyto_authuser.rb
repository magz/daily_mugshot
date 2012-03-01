class AddConsistencytoAuthuser < ActiveRecord::Migration
  def up
    change_table :authusers do |t|
      t.integer :consistency
    end
  end

  def down
    remove_column :authusers, :consistency
  end
end

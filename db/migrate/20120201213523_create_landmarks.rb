class CreateLandmarks < ActiveRecord::Migration
  def change
    create_table :landmarks do |t|
      t.integer :authuser_id
      t.integer :xcoord
      t.integer :ycoord

      t.timestamps
    end
  end
end

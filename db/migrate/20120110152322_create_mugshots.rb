class CreateMugshots < ActiveRecord::Migration
  def change
    create_table :mugshots do |t|
      t.integer :authuser_id
      t.string :caption
      t.integer :xoffset
      t.integer :yoffset
      t.boolean :active

      t.timestamps
    end
  end
end
mestamps
    end
  end
end

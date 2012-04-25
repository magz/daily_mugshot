class Trythatagain < ActiveRecord::Migration
  def change
    create_table :mugshots do |t|
      t.integer :authuser_id
      t.string :caption
      t.integer :xoffset
      t.integer :yoffset
      t.boolean :active
      t.string   :image_file_name
      t.integer  :image_file_size
      t.datetime :image_updated_at
      t.datetime :updated_at
      t.string   :image_content_type
      t.boolean  :transfer_error
      t.string   :filename
      t.datetime :deleted_at
      
      t.timestamps
    end
  end
end
mestamps
    end
  end
end

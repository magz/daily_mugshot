class AddImageDataToMugshot < ActiveRecord::Migration
  def self.up
    change_table :mugshots do |t|
      t.string :image_file_name
      t.integer :image_file_size
      t.string :image_content_type
      t.datetime :image_updated_at
    end
  end

  def self.down
    remove_column :mugshots, :image_file_name
    remove_column :mugshots, :image_file_size
    remove_column :mugshots, :image_content_type
    remove_column :mugshots, :image_updated_at
    
  end
end
_updated_at
    
  end
end

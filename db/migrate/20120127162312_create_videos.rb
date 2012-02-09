class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :authuser_id
      t.string :description
      t.string :url

      t.timestamps
    end
  end
end

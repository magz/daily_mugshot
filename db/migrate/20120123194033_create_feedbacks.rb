class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :authuser_id
      t.string :email
      t.text :body

      t.timestamps
    end
  end
end

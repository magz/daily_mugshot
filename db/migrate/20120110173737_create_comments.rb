class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :authuser_id
      t.integer :mugshot_id
      t.string :body

      t.timestamps
    end
  end
end

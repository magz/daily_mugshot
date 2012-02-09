class CreateTwitterConnects < ActiveRecord::Migration
  def change
    create_table :twitter_connects do |t|
      t.integer :authuser_id
      t.string :token
      t.string :secret
      t.boolean :active

      t.timestamps
    end
  end
end

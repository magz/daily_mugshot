class CreateAuthusers < ActiveRecord::Migration
  def change
    create_table :authusers do |t|
      t.string :login
      t.string :email
      t.string :crypted_password
      t.boolean :active
      t.string :time_zone
      t.string :gender
      t.date :birthday
      t.boolean :prvt

      t.timestamps
    end
  end
end

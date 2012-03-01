class AddDeletedAttoComments < ActiveRecord::Migration
    def up
      change_table :comments do |t|
        t.datetime :deleted_at

      end
    end

    def down
      remove_column :comments, :deleted_at
    end
  end

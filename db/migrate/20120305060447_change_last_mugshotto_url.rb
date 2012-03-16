class ChangeLastMugshottoUrl < ActiveRecord::Migration
    def up
      change_table :authusers do |t|
        t.string :last_mugshot_url
      end
    end

    def down
      remove_column :authusers, :last_mugshot_url
    end
  end

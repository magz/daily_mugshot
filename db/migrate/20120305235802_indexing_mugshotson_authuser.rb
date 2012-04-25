class IndexingMugshotsonAuthuser < ActiveRecord::Migration
    def self.up
      add_index :mugshots, :authuser_id 
    end

    def self.down
      remove_index :mugshots, :column => :authuser_id
    end
  end 
authuser_id
    end
  end 

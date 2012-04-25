class RenameFriendIdtoFollowee < ActiveRecord::Migration
  def up
    rename_column :friendships, :friend_id, :followee_id
  
  end

  def down
    rename_column :friendships, :followee_id, :friend_id
    
  end
end
 :friend_id
    
  end
end

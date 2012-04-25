class RenameMugshotIdtoOwnerIdComments < ActiveRecord::Migration
  def up
    rename_column :comments, :mugshot_id, :owner_id
  end

  def down
    rename_column :comments, :owner_id, :mugshot_id
    
  end
end
:mugshot_id
    
  end
end

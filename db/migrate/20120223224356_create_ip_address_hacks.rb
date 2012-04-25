class CreateIpAddressHacks < ActiveRecord::Migration
  def change
    create_table :ip_address_hacks do |t|
      t.string :authuser_id
      t.string :ip_address

      t.timestamps
    end
  end
end
mestamps
    end
  end
end

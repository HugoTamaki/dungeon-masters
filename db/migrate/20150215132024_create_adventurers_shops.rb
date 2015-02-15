class CreateAdventurersShops < ActiveRecord::Migration
  def change
    create_table :adventurers_shops do |t|
      t.integer :adventurer_id
      t.integer :modifier_shop_id
      t.integer :quantity

      t.timestamps
    end
  end
end

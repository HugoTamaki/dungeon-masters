class CreateAdventurersItems < ActiveRecord::Migration
  def change
    create_table :adventurers_items do |t|
      t.integer :adventurer_id, index: true
      t.integer :item_id, index: true
      t.integer :status

      t.timestamps
    end
  end
end

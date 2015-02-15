class CreateModifiersShops < ActiveRecord::Migration
  def change
    create_table :modifiers_shops do |t|
      t.integer :chapter_id
      t.integer :item_id
      t.integer :price
      t.integer :quantity

      t.timestamps
    end
  end
end

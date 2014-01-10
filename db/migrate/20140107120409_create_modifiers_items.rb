class CreateModifiersItems < ActiveRecord::Migration
  def change
    create_table :modifiers_items do |t|
      t.integer :chapter_id
      t.integer :item_id
      t.integer :quantity

      t.timestamps
    end
  end
end

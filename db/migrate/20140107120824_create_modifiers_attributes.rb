class CreateModifiersAttributes < ActiveRecord::Migration
  def change
    create_table :modifiers_attributes do |t|
      t.integer :chapter_id
      t.string :attribute
      t.integer :quantity

      t.timestamps
    end
  end
end

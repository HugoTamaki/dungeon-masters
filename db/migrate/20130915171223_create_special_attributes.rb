class CreateSpecialAttributes < ActiveRecord::Migration
  def change
    create_table :special_attributes do |t|
      t.string :name, limit: 40
      t.integer :adventurer_id, index: true
      t.integer :story_id, index: true
      t.integer :value

      t.timestamps
    end
  end
end

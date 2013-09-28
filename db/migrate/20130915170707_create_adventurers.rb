class CreateAdventurers < ActiveRecord::Migration
  def change
    create_table :adventurers do |t|
      t.string :name, limit: 40
      t.integer :user_id, index: true
      t.integer :ability
      t.integer :energy
      t.integer :luck
      t.integer :gold

      t.timestamps
    end
  end
end

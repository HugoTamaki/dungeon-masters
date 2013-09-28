class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
      t.string :name, limit: 40
      t.integer :ability
      t.integer :energy
      t.integer :story_id, index: true

      t.timestamps
    end
  end
end

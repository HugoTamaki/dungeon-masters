class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
      t.string :name, limit: 40
      t.integer :skill
      t.integer :energy
      t.integer :chapter_id, index: true

      t.timestamps
    end
  end
end

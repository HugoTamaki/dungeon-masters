class CreateAdventurerChapters < ActiveRecord::Migration
  def change
    create_table :adventurer_chapters do |t|
      t.integer :adventurer_id
      t.integer :chapter_id

      t.timestamps
    end
  end
end

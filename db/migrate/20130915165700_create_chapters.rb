class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.integer :story_id, index: true
      t.string :reference, limit: 10
      t.text :content

      t.timestamps
    end
  end
end

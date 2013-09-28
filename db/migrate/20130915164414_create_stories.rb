class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title, limit: 40
      t.text :resume
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end

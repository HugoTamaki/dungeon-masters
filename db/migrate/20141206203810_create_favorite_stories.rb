class CreateFavoriteStories < ActiveRecord::Migration
  def change
    create_table :favorite_stories do |t|
      t.integer :user_id
      t.integer :story_id

      t.timestamps
    end
  end
end

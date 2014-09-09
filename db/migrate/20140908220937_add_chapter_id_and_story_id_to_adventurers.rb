class AddChapterIdAndStoryIdToAdventurers < ActiveRecord::Migration
  def change
    add_column :adventurers, :chapter_id, :integer
    add_column :adventurers, :story_id, :integer
  end
end

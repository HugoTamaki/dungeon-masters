class AddChapterNumbersToStories < ActiveRecord::Migration
  def change
    add_column :stories, :chapter_numbers, :integer, default: 0
  end
end

class ChangeDefaultOfChapterNumbers < ActiveRecord::Migration
  def change
    change_column_default(:stories, :chapter_numbers, nil)
  end
end

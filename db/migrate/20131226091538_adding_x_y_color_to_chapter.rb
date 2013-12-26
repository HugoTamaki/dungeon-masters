class AddingXYColorToChapter < ActiveRecord::Migration
  def up
    add_column :chapters, :x, :float
    add_column :chapters, :y, :float
    add_column :chapters, :color, :string
  end

  def down
    remove_column :chapters, :x
    remove_column :chapters, :y
    remove_column :chapters, :color
  end
end

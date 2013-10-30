class AddPreludeToStory < ActiveRecord::Migration
  def self.up
    add_column :stories, :prelude, :text
  end

  def self.down
    remove_column :stories, :prelude
  end
end

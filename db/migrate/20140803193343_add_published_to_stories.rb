class AddPublishedToStories < ActiveRecord::Migration
  def change
    add_column :stories, :published, :boolean, default: false
  end
end

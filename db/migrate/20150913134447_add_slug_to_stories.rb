class AddSlugToStories < ActiveRecord::Migration
  def change
    add_column :stories, :slug, :string
    add_index :stories, :slug
  end
end

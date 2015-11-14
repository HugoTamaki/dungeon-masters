class AddParentAndChildColumnsToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :has_parent, :boolean, default: false
    add_column :chapters, :has_children, :boolean, default: false
  end
end

class AddUsableToItems < ActiveRecord::Migration
  def change
    add_column :items, :usable, :boolean, default: false
  end
end

class AddModifierToItems < ActiveRecord::Migration
  def change
    add_column :items, :modifier, :integer, default: 0
  end
end

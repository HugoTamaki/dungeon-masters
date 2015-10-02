class AddTypeToItems < ActiveRecord::Migration
  def change
    add_column :items, :type, :string, default: 'UsableItem'
  end
end

class AddAttributeToItems < ActiveRecord::Migration
  def change
    add_column :items, :attr, :string, default: ''
  end
end

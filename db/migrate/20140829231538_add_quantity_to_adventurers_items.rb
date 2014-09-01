class AddQuantityToAdventurersItems < ActiveRecord::Migration
  def change
    add_column :adventurers_items, :quantity, :integer, default: 0
  end
end

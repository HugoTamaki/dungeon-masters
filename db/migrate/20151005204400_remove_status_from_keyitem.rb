class RemoveStatusFromKeyitem < ActiveRecord::Migration
  def change
    remove_column :adventurers_items, :status, :integer
    add_column :adventurers_items, :selected, :boolean, defalt: false
  end
end

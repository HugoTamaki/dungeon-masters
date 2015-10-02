class AddDamageToItem < ActiveRecord::Migration
  def change
    add_column :items, :damage, :integer, default: 2
  end
end

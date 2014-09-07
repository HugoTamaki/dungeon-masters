class DropTableSpecialAttributes < ActiveRecord::Migration
  def change
    drop_table :special_attributes
  end
end

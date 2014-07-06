class AddItemValidatorToDecisions < ActiveRecord::Migration
  def change
    add_column :decisions, :item_validator, :integer
  end
end

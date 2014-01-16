class ChangeColumnAttributeOnModifier < ActiveRecord::Migration
  def self.up
    rename_column :modifiers_attributes, :attribute, :attr
  end

  def self.down
    rename_column :modifiers_attributes, :attribute, :attr
  end
end

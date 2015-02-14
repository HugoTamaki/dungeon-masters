class AddInitialGoldToStory < ActiveRecord::Migration
  def change
    add_column :stories, :initial_gold, :integer, default: 0
  end
end

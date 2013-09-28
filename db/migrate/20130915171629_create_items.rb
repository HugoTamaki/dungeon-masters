class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name, limit: 40
      t.text :description
      t.integer :story_id, index: true

      t.timestamps
    end
  end
end

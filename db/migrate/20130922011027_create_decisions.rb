class CreateDecisions < ActiveRecord::Migration
  def change
    create_table :decisions do |t|
      t.integer :chapter_id
      t.integer :destiny_num

      t.timestamps
    end
  end
end

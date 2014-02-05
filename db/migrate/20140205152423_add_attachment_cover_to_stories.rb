class AddAttachmentCoverToStories < ActiveRecord::Migration
  def self.up
    change_table :stories do |t|
      t.attachment :cover
    end
  end

  def self.down
    drop_attached_file :stories, :cover
  end
end

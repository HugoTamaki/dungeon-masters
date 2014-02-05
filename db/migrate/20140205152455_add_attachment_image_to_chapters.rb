class AddAttachmentImageToChapters < ActiveRecord::Migration
  def self.up
    change_table :chapters do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :chapters, :image
  end
end

class Chapter < ActiveRecord::Base
  attr_accessible :content, :reference, :story_id, :image, :decisions_attributes

  mount_uploader :image, ImageUploader
  belongs_to :story
  has_many :decisions

 accepts_nested_attributes_for :decisions, reject_if: :all_blank, allow_destroy: true
end

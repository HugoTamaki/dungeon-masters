class Chapter < ActiveRecord::Base
  attr_accessible :content, 
                  :reference,
                  :story_id,
                  :image,
                  :decisions_attributes,
                  :monsters_attributes

  mount_uploader :image, ImageUploader
  belongs_to :story
  has_many :monsters, dependent: :destroy
  has_many :decisions, dependent: :destroy
  has_many :monsters, dependent: :destroy

  accepts_nested_attributes_for :decisions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :monsters, reject_if: :all_blank, allow_destroy: true

  scope :by_story, lambda {|story_id| where(story_id: story_id)}

  validate :image_size_validation

  def self.exist(destiny,story_id)
    chapter_exist = false
    chapters = Chapter.by_story(story_id)
    chapters.each do |chapter|
      if chapter.reference == destiny.to_s
        chapter_exist = true
        break
      end
    end
    chapter_exist
  end

  private

  def image_size_validation
    flash[:alert] << "should be less than 300KB" if image.size > 300.kilobytes
  end
end

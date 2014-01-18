class Chapter < ActiveRecord::Base
  attr_accessible :content, 
                  :reference,
                  :story_id,
                  :image,
                  :decisions_attributes,
                  :monsters_attributes,
                  :modifiers_items_attributes,
                  :modifiers_attributes_attributes,
                  :items_attributes,
                  :x,
                  :y,
                  :color

  mount_uploader :image, ImageUploader
  belongs_to :story
  has_many :decisions, dependent: :destroy
  has_many :monsters, dependent: :destroy
  has_many :modifiers_items, dependent: :destroy
  has_many :modifiers_attributes, dependent: :destroy

  accepts_nested_attributes_for :decisions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :monsters, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :modifiers_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :modifiers_attributes, reject_if: :all_blank, allow_destroy: true

  scope :by_story, lambda {|story_id| where(story_id: story_id)}

  validate :image_size_validation
  validates :content, presence: true

  before_create do
    self.x = Random.rand.round(3)
    self.y = Random.rand.round(3)
    number = Random.rand(6) + 1
    case number
    when 1
      self.color = "#CCFF00"
    when 2
      self.color = "#CC00FF"
    when 3
      self.color = "#00CCFF"
    when 4
      self.color = "#FF3300"
    when 5
      self.color = "#FF9900"
    when 6
      self.color = "#FFFF00"
    end
  end

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

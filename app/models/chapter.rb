class Chapter < ActiveRecord::Base
  attr_accessible :content, 
                  :reference,
                  :story_id,
                  :decisions_attributes,
                  :monsters_attributes,
                  :modifiers_items_attributes,
                  :modifiers_attributes_attributes,
                  :items_attributes,
                  :image,
                  :x,
                  :y,
                  :color

  has_attached_file :image, styles: {thumbnail: "200x200>"}
  belongs_to :story
  has_many :decisions, dependent: :destroy
  has_many :monsters, dependent: :destroy
  has_many :modifiers_items, dependent: :destroy
  has_many :modifiers_attributes, dependent: :destroy

  validates_attachment_size :image, :less_than => 300.kilobytes
  validates_attachment_content_type :image, content_type: ["image/jpg", "image/png", "image/gif", "image/jpeg"]

  accepts_nested_attributes_for :decisions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :monsters, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :modifiers_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :modifiers_attributes, reject_if: :all_blank, allow_destroy: true

  scope :by_story, lambda {|story_id| where(story_id: story_id)}

  before_create do
    self.x = Random.rand.round(10)
    self.y = Random.rand.round(10)
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

end

# == Schema Information
#
# Table name: chapters
#
#  id                 :integer          not null, primary key
#  story_id           :integer
#  reference          :string(10)
#  content            :text
#  created_at         :datetime
#  updated_at         :datetime
#  image              :string(255)
#  x                  :float
#  y                  :float
#  color              :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Chapter < ActiveRecord::Base

  has_attached_file :image, styles: {thumbnail: "200x200>",normal: "600x600>"}
  belongs_to :story, touch: true
  has_many :adventurers, dependent: :destroy
  has_many :decisions, dependent: :destroy
  has_many :monsters, dependent: :destroy
  has_many :modifiers_items, dependent: :destroy
  has_many :modifiers_attributes, dependent: :destroy
  has_many :modifiers_shops, dependent: :destroy

  validates_attachment_size :image, :less_than => 2.megabytes
  validates_attachment_content_type :image, content_type: ["image/jpg", "image/png", "image/gif", "image/jpeg"]

  accepts_nested_attributes_for :decisions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :monsters, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :modifiers_items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :modifiers_attributes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :modifiers_shops, reject_if: :all_blank, allow_destroy: true

  scope :by_story, -> (story_id) { where(story_id: story_id) }
  scope :by_reference, -> (reference) { where(reference: reference) }

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

  def has_parent?
    decision = Decision.find_by(destiny_num: self.id)
    if decision
      chapters = decision.chapter.story.chapters
      chapters.each do |c|
        c.decisions.each do |d|
          if decision == d
            return true
          end
        end
      end
    end
    false
  end
end

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
    self.color = ["#CCFF00","#CC00FF","#00CCFF","#FF3300","#FF9900","#FFFF00"].sample
    self.x = rand
    self.y = rand
  end

  before_save :check_parent_and_children

  def check_children
    decisions.where.not(destiny_num: nil).count > 0
  end

  def check_parents
    Decision.joins(:chapter).where(chapters: {story_id: self.story.id}, decisions: {destiny_num: self.id}).present?
  end

  class << self
    def get_references
      select { |chapter| chapter.has_parent? || chapter.has_children? }
      .map { |chapter| {
            number: chapter.reference, 
            x: chapter.x,
            y: chapter.y,
            color: chapter.color,
            description: chapter.content.present? ? chapter.content.truncate(200, separator: '</div>').html_safe : nil
          } }
    end

    def get_destinies
      select { |chapter| chapter.has_parent? || chapter.has_children? }
      .map { |chapter| {
          source: chapter.reference,
          destinies: chapter.decisions
                      .reject { |decision| decision.destiny_num.nil? }
                      .map { |decision| Chapter.find(decision.destiny_num).reference.to_i },
          infos: [chapter.x, chapter.y, chapter.color]
        } }
    end

    def get_not_used_references
      all.reject { |chapter| chapter.reference == "1" || chapter.has_parent? }.map { |chapter| chapter.reference }
    end

    def validate_chapters(chapters_with_decisions)
      chapters_with_decisions.all? { |decisions| decisions.uniq.length == decisions.length }
    end
  end

  private

    def check_parent_and_children
      self.has_parent = true if check_parents
      self.has_children = true if check_children
    end
end

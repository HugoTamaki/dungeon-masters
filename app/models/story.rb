# == Schema Information
#
# Table name: stories
#
#  id                 :integer          not null, primary key
#  title              :string(40)
#  resume             :text
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  prelude            :text
#  cover              :string(255)
#  cover_file_name    :string(255)
#  cover_content_type :string(255)
#  cover_file_size    :integer
#  cover_updated_at   :datetime
#  published          :boolean          default(FALSE)
#  chapter_numbers    :integer
#  initial_gold       :integer          default(0)
#

class Story < ActiveRecord::Base
  extend FriendlyId  
  friendly_id :title, use: [:slugged, :finders]

  before_destroy :destroy_favorites

  has_attached_file :cover, styles: {thumbnail: "200x200>", index_cover: "400x300>"}, :default_url => "no_image_:style.png"

  validates :title, presence: true
  validates :resume, presence: true
  validates :chapter_numbers, presence: true, numericality: true
  validates_attachment_size :cover, :less_than => 2.megabytes
  validates_attachment_content_type :cover, content_type: ["image/jpg", "image/png", "image/gif", "image/jpeg"]

  belongs_to :user
  has_many :adventurers, dependent: :destroy
  has_many :chapters, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :comments
  has_many :favorite_stories
  has_many :favorited_by, through: :favorite_stories, source: :user
  accepts_nested_attributes_for :chapters, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  scope :by_user, -> (user_id) { where(user_id: user_id) }
  scope :published, -> { where(published: true) }

  def weapons
    items.weapons
  end

  def usable_items
    items.usable_items
  end

  def key_items
    items.key_items
  end

  def has_adventurer? adventurers
    adventurers.any? {|adventurer| adventurer.story == self}
  end

  def build_chapters chapter_numbers
    for i in (1..chapter_numbers)
      chapter = self.chapters.build
      chapter.decisions.build
      chapter.reference = i
      chapter.save
    end
  end

  def self.graph(chapters)
    chapters_with_decisions = {
      references: chapters.get_references,
      chapter_destinies: chapters.get_destinies,
      not_used: chapters.get_not_used_references
    }
    chapters_with_decisions[:valid] = Chapter.validate_chapters(chapters_with_decisions)
    chapters_with_decisions
  end

  def self.search(search)
    joins('LEFT JOIN users AS u 
            ON u.id = stories.user_id').where('u.name LIKE :search 
            OR stories.title LIKE :search', search: "%#{search}%").order('stories.title ASC') if search
  end

  def destroy_favorites
    favorites_to_destroy = FavoriteStory.where(story_id: self.id)
    favorites_to_destroy.destroy_all
  end
end

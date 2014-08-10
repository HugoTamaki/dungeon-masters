class Story < ActiveRecord::Base

  has_attached_file :cover, styles: {thumbnail: "200x200>", index_cover: "400x300>"}, :default_url => "no_image_:style.png"

  validates :title, presence: true
  validates :resume, presence: true
  validates :chapter_numbers, presence: true, numericality: true
  validates_attachment_size :cover, :less_than => 300.kilobytes
  validates_attachment_content_type :cover, content_type: ["image/jpg", "image/png", "image/gif", "image/jpeg"]

  belongs_to :user
  has_many :chapters, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :special_attributes, dependent: :destroy
  accepts_nested_attributes_for :chapters, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :special_attributes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  scope :by_user, lambda {|user_id| where(user_id: user_id)}
  scope :published, -> { where(published: true) }

  def self.graph(chapters)
    references = []
    chapters_with_decisions = {}
    chapters.each do |c|
      references << c.reference if c.reference == "1" || c.has_parent?
    end

    chapters_with_decisions["references"] = references
    destines = []

    chapters.each do |c|
      aux = []
      aux << c.reference
      c.decisions.each do |d|
        aux << Chapter.find(d.destiny_num).reference.to_i unless d.destiny_num.nil?
      end
      destines << aux
    end

    chapters_with_decisions["chapter_destinies"] = destines

    infos = []

    chapters.each do |c|
      aux = []
      infos << [c.x, c.y, c.color]
    end

    chapters_with_decisions["infos"] = infos

    duplicates = []
    chapters_with_decisions["chapter_destinies"].each do |decisions|
      duplicates << decisions.select {|element| decisions.count(element) > 1}
    end

    chapters_with_decisions["valid"] = []
    duplicates.each do |duplicate|
      if duplicate.empty?
        chapters_with_decisions["valid"] << true
      else
        chapters_with_decisions["valid"] << false
      end
    end

    references = []
    decisions = []

    chapters.each do |chapter|
      references << chapter.reference.to_i
    end

    chapters.each do |chapter|
      chapter.decisions.each do |decision|
        decisions << Chapter.find(decision.destiny_num).reference.to_i unless decision.destiny_num.nil?
      end
    end

    chapters_with_decisions["not_used"] = references - decisions

    chapters_with_decisions
  end

  def self.search(search)
    joins('LEFT JOIN users AS u 
            ON u.id = stories.user_id').where('u.name LIKE :search 
            OR stories.title LIKE :search', search: "%#{search}%").order('stories.title ASC') if search
  end

end

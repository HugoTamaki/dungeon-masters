class Story < ActiveRecord::Base
  attr_accessible :resume,
                  :title,
                  :prelude,
                  :items_attributes,
                  :chapters_attributes,
                  :special_attributes_attributes,
                  :user_id,
                  :cover,
                  :chapter_numbers

  attr_accessor :chapter_numbers

  mount_uploader :cover, ImageUploader

  validates :title, presence: true
  validates :resume, presence: true
  validate :image_size_validation

  belongs_to :user
  has_many :chapters, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :special_attributes, dependent: :destroy
  accepts_nested_attributes_for :chapters, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :special_attributes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  scope :by_user, lambda {|user_id| where(user_id: user_id)}

  def self.graph(chapters,id)
    references = []
    chapters_with_decisions = {}
    chapters.each do |c|
      references << c.reference
      #      chapters_with_decisions["chapter #{c.reference}"] = nil
    end

    chapters_with_decisions["references"] = references
    destines = []

    chapters.each do |c|
      aux = []
      aux << c.reference
      c.decisions.each do |d|
        if Chapter.exist(d.destiny_num,id)
          aux << d.destiny_num
        end
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
        decisions << decision.destiny_num unless decision.destiny_num.nil?
      end
    end

    chapters_with_decisions["not_used"] = references - decisions

    chapters_with_decisions
  end

  def self.search(search,user_id)
    if search
      joins(:user).where('stories.title LIKE ? or users.name LIKE ?', "%#{search}%", "%#{search}%")
    else
      by_user(user_id)
    end
  end

  def image_size_validation
    flash[:alert] << "should be less than 300KB" if cover.size > 300.kilobytes
  end
end

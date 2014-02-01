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

  def self.graph(chapters)
    nodes = []
    edges = []
    references = []
    decisions = []

    chapters.each do |chapter|
      node = {}
      node["id"] = chapter.reference
      node["label"] = chapter.reference
      node["x"] = chapter.x
      node["y"] = chapter.y
      node["size"] = 1
      node["color"] = chapter.color
      nodes << node
      references << chapter.reference.to_i
      if chapter.decisions.present?
        chapter.decisions.each do |decision|
          if decision.destiny_num.present?
            edge = {}
            edge["id"] = chapter.reference + decision.destiny_num.to_s
            edge["source"] = chapter.reference
            edge["target"] = decision.destiny_num.to_s
            edges << edge
            decisions << decision.destiny_num
          end
        end
      end
    end
    data = {}
    graph = {}
    graph[:nodes] = nodes
    graph[:edges] = edges
    data[:graph] = graph
    data[:not_used] = references - decisions

    data
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

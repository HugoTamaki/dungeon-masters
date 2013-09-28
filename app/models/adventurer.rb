class Adventurer < ActiveRecord::Base
  attr_accessible :ability, :energy, :gold, :luck, :name, :user_id

  validates :ability, presence: true, numericality: true
  validates :energy, presence: true, numericality: true
  validates :luck, presence: true, numericality: true

  belongs_to :user
  has_many :adventurers_items, inverse_of: :adventurer, dependent: :destroy
  has_many :items, through: :adventurers_items
  has_many :special_attributes
  accepts_nested_attributes_for :adventurers_items, reject_if: :all_blank, allow_destroy: true
end

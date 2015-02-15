# == Schema Information
#
# Table name: adventurers_shops
#
#  id               :integer          not null, primary key
#  adventurer_id    :integer
#  modifier_shop_id :integer
#  quantity         :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe AdventurerShop do
  pending "add some examples to (or delete) #{__FILE__}"
end

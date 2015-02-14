# == Schema Information
#
# Table name: favorite_stories
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  story_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe FavoriteStory do
  pending "add some examples to (or delete) #{__FILE__}"
end

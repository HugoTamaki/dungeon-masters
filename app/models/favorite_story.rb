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

class FavoriteStory < ActiveRecord::Base
  belongs_to :user
  belongs_to :story
end

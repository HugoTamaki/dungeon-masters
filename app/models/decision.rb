# == Schema Information
#
# Table name: decisions
#
#  id             :integer          not null, primary key
#  chapter_id     :integer
#  destiny_num    :integer
#  created_at     :datetime
#  updated_at     :datetime
#  item_validator :integer
#

class Decision < ActiveRecord::Base

  belongs_to :chapter, touch: true

  def child
    begin
      story = self.chapter.story
      Chapter.by_story(story).find(self.destiny_num) unless self.destiny_num.nil?
    rescue
      nil
    end
  end
end

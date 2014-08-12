class Decision < ActiveRecord::Base

  belongs_to :chapter

  def child
    begin
      story = self.chapter.story
      Chapter.by_story(story).find(self.destiny_num) unless self.destiny_num.nil?
    rescue
      nil
    end
  end
end

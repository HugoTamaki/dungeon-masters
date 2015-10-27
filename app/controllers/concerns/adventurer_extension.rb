module AdventurerExtension
  def set_gold_items_and_attributes(user)
    @adventurer = Adventurer.by_user_and_story(current_user, @story).first
    @adventurer.set_chapter_and_gold(@chapter, @story, params[:reference])
    @adventurer.attribute_and_item_changer(@chapter)
    @adventurers_items = AdventurerItem.by_adventurer(@adventurer)
    @adventurer.chapters << @chapter unless @adventurer.chapters.include? @chapter
  end
end
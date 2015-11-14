module ChapterExtension
  def format_publish_message(story, options={})
    if options[:success]
      if story.published
        data = {
          button: I18n.t('actions.unpublish'),
          message: I18n.t('actions.publish_success')
        }
      else
        data = {
          button: I18n.t('actions.publish'),
          message: I18n.t('actions.unpublish_success')
        }
      end
    else
      if story.published
        data = {
          message: I18n.t('actions.unpublish_fail')
        }
      else
        data = {
          message: I18n.t('actions.publish_fail')
        }
      end
    end
    data
  end

  def get_errors(story)
    errors = []
    story.errors.full_messages.each do |error|
      errors << error
    end
    errors
  end

  def get_chapters_with_errors(story)
    chapters = ""
    story.chapters.each do |chapter|
      if chapter.errors.any?
        chapters << chapter.reference + ", "
      end
    end
    chapters[0...-2]
  end

  def add_chapters_by_quantity(story, num_chapters)
    if story.chapters.present?
      last_known_reference = story.chapters.last.reference.to_i + 1
    else
      last_chapter_reference = 1
    end
    quantity = num_chapters - 1
    last_chapter_reference = last_known_reference + quantity

    ActiveRecord::Base.transaction do
      (last_known_reference..last_chapter_reference).each do |i|
        Chapter.create(story: story, reference: i)
      end
    end
    story.chapter_numbers = story.chapters.last.reference.to_i
    story.save

    case num_chapters
    when 5
      message = I18n.t('actions.messages.five_more')
    when 10
      message = I18n.t('actions.messages.ten_more')
    when 20
      message = I18n.t('actions.messages.twenty_more')
    when 50
      message = I18n.t('actions.messages.fifty_more')
    end
    message
  end

  def remove_chapters_by_quantity(story, num_chapters)
    story.chapters.last(num_chapters).each(&:destroy) if story.chapters.count >= num_chapters

    case num_chapters
    when 5
      message = I18n.t('actions.messages.five_less')
    when 10
      message = I18n.t('actions.messages.ten_less')
    when 20
      message = I18n.t('actions.messages.twenty_less')
    when 50
      message = I18n.t('actions.messages.fifty_less')
    end
    message
  end

  def generate_chapters(chapter_numbers)
    if @story.chapters.empty?
      if chapter_numbers.present?
        @story.build_chapters(chapter_numbers)
      else
        chapter = @story.chapters.build
        chapter.decisions.build
      end
    end
  end
end
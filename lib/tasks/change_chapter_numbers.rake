namespace :change do
  

  desc 'Change chapter numbers value'
  task chapter_numbers: :environment do
    stories = Story.all

    stories.each do |story|
      story.chapter_numbers = story.chapters.last.reference.to_i
      story.save
    end
  end
end
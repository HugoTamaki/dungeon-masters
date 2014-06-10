require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Calabouco
  
  STORY_CHAPTER_NUMBERS = "Insert how many chapters you want your story to have. If you want to insert more chapters, don't worry, you can do that later."
  STORY_RESUME = "This is the text that will be a quick resume of your story. It will be visible to users that search your story."
  STORY_PRELUDE = "This is the start of your story. Here you can explain who is the protagonist, or what are his motivations."
  CHAPTER_REFERENCE = "Links chapters to each other. The first chapter must have reference 1."
  CHAPTER_CONTENT = "The content of the chapter."
  CHAPTER_DESTINY = "It will point to the next chapter. Insert as many decisions you want in a Chapter."
  CHAPTER_MONSTER_NAME = "The monster's name. Use different names for each chapter. ex: goblin A, goblin B"
  CHAPTER_MONSTER_SKILL = "Monster's ability or dexterity. If it's high, it will be more difficult to win over a monster."
  CHAPTER_MONSTER_ENERGY = "Monster's hit point. If it's high, the monster will have more vitality."
  CHAPTER_MOD_ITEM = "Choose here how many items you want the adventurer to receive in the chapter, and above, which item."
  CHAPTER_MOD_ATTRIBUTE = "Choose here how much the adventurer will loose or gain of an attribute. Eg. -3, 4. Choose which attribute above."

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
  end
end

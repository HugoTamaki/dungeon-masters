# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
 ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
   inflect.irregular 'person', 'people'
   inflect.irregular 'special_attribute', 'special_attributes'
   inflect.irregular 'SpecialAttribute', 'SpecialAttributes'
   inflect.irregular 'adventurer_item', 'adventurers_items'
   inflect.irregular 'AdventurerItem', 'AdventurersItems'
   inflect.irregular 'adventurer_shop', 'adventurers_shops'
   inflect.irregular 'AdventurerShop', 'AdventurersShops'
   inflect.irregular 'ChapterMonster', 'ChaptersMonsters'
   inflect.irregular 'chapter_monster', 'chapters_monsters'
   inflect.irregular 'modifier_item', 'modifiers_items'
   inflect.irregular 'ModifierItem', 'ModifiersItems'
   inflect.irregular 'modifier_attribute', 'modifiers_attributes'
   inflect.irregular 'ModifierAttribute', 'ModifiersAttributes'
   inflect.irregular 'ModifierShop', 'ModifiersShops'
   inflect.irregular 'modifier_shop', 'modifiers_shops'
#   inflect.uncountable %w( fish sheep )
 end
#
# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.acronym 'RESTful'
# end

# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141206182019) do

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.index ["email"], :name => "index_users_on_email", :unique => true
    t.index ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  end

  create_table "stories", force: true do |t|
    t.string   "title",              limit: 40
    t.text     "resume"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "prelude"
    t.string   "cover"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.boolean  "published",                     default: false
    t.integer  "chapter_numbers"
    t.index ["user_id"], :name => "index_stories_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_stories_user_id"
  end

  create_table "chapters", force: true do |t|
    t.integer  "story_id"
    t.string   "reference",          limit: 10
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.float    "x"
    t.float    "y"
    t.string   "color"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.index ["story_id"], :name => "index_chapters_on_story_id"
    t.foreign_key ["story_id"], "stories", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_chapters_story_id"
  end

  create_table "adventurers", force: true do |t|
    t.string   "name",       limit: 40
    t.integer  "user_id"
    t.integer  "skill"
    t.integer  "energy"
    t.integer  "luck"
    t.integer  "gold"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter_id"
    t.integer  "story_id"
    t.index ["chapter_id"], :name => "fk__adventurers_chapter_id"
    t.index ["story_id"], :name => "fk__adventurers_story_id"
    t.index ["user_id"], :name => "index_adventurers_on_user_id"
    t.foreign_key ["chapter_id"], "chapters", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_adventurers_chapter_id"
    t.foreign_key ["story_id"], "stories", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_adventurers_story_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_adventurers_user_id"
  end

  create_table "adventurer_chapters", force: true do |t|
    t.integer  "adventurer_id"
    t.integer  "chapter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["adventurer_id"], :name => "fk__adventurer_chapters_adventurer_id"
    t.index ["chapter_id"], :name => "fk__adventurer_chapters_chapter_id"
    t.foreign_key ["adventurer_id"], "adventurers", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_adventurer_chapters_adventurer_id"
    t.foreign_key ["chapter_id"], "chapters", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_adventurer_chapters_chapter_id"
  end

  create_table "items", force: true do |t|
    t.string   "name",        limit: 40
    t.text     "description"
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "usable"
    t.string   "attr"
    t.integer  "modifier"
    t.index ["story_id"], :name => "index_items_on_story_id"
    t.foreign_key ["story_id"], "stories", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_items_story_id"
  end

  create_table "adventurers_items", force: true do |t|
    t.integer  "adventurer_id"
    t.integer  "item_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",      default: 0
    t.index ["adventurer_id"], :name => "index_adventurers_items_on_adventurer_id"
    t.index ["item_id"], :name => "index_adventurers_items_on_item_id"
    t.foreign_key ["adventurer_id"], "adventurers", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_adventurers_items_adventurer_id"
    t.foreign_key ["item_id"], "items", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_adventurers_items_item_id"
  end

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "story_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["story_id"], :name => "fk__comments_story_id"
    t.index ["user_id"], :name => "fk__comments_user_id"
    t.foreign_key ["story_id"], "stories", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_comments_story_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_comments_user_id"
  end

  create_table "decisions", force: true do |t|
    t.integer  "chapter_id"
    t.integer  "destiny_num"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_validator"
    t.index ["chapter_id"], :name => "fk__decisions_chapter_id"
    t.foreign_key ["chapter_id"], "chapters", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_decisions_chapter_id"
  end

  create_table "modifiers_attributes", force: true do |t|
    t.integer  "chapter_id"
    t.string   "attr"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["chapter_id"], :name => "fk__modifiers_attributes_chapter_id"
    t.foreign_key ["chapter_id"], "chapters", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_modifiers_attributes_chapter_id"
  end

  create_table "modifiers_items", force: true do |t|
    t.integer  "chapter_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["chapter_id"], :name => "fk__modifiers_items_chapter_id"
    t.index ["item_id"], :name => "fk__modifiers_items_item_id"
    t.foreign_key ["chapter_id"], "chapters", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_modifiers_items_chapter_id"
    t.foreign_key ["item_id"], "items", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_modifiers_items_item_id"
  end

  create_table "monsters", force: true do |t|
    t.string   "name",       limit: 40
    t.integer  "skill"
    t.integer  "energy"
    t.integer  "chapter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["chapter_id"], :name => "index_monsters_on_chapter_id"
    t.foreign_key ["chapter_id"], "chapters", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "fk_monsters_chapter_id"
  end

end

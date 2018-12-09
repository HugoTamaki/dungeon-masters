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

ActiveRecord::Schema.define(version: 20151113222203) do

  create_table "users", force: :cascade do |t|
    t.string   "email",                  :limit=>255, :default=>"", :null=>false, :index=>{:name=>"index_users_on_email", :unique=>true, :using=>:btree}
    t.string   "encrypted_password",     :limit=>255, :default=>"", :null=>false
    t.string   "reset_password_token",   :limit=>255, :index=>{:name=>"index_users_on_reset_password_token", :unique=>true, :using=>:btree}
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :limit=>4, :default=>0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     :limit=>255
    t.string   "last_sign_in_ip",        :limit=>255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   :limit=>255
    t.text     "about_me",               :limit=>65535
  end

  create_table "stories", force: :cascade do |t|
    t.string   "title",              :limit=>40
    t.text     "resume",             :limit=>65535
    t.integer  "user_id",            :limit=>4, :index=>{:name=>"index_stories_on_user_id", :using=>:btree}, :foreign_key=>{:references=>"users", :name=>"fk_stories_user_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "prelude",            :limit=>65535
    t.string   "cover",              :limit=>255
    t.string   "cover_file_name",    :limit=>255
    t.string   "cover_content_type", :limit=>255
    t.integer  "cover_file_size",    :limit=>4
    t.datetime "cover_updated_at"
    t.boolean  "published",          :default=>false
    t.integer  "chapter_numbers",    :limit=>4
    t.integer  "initial_gold",       :limit=>4, :default=>0
    t.string   "slug",               :limit=>255, :index=>{:name=>"index_stories_on_slug", :unique=>true, :using=>:btree}
  end

  create_table "chapters", force: :cascade do |t|
    t.integer  "story_id",           :limit=>4, :index=>{:name=>"index_chapters_on_story_id", :using=>:btree}, :foreign_key=>{:references=>"stories", :name=>"fk_chapters_story_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.string   "reference",          :limit=>10
    t.text     "content",            :limit=>65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image",              :limit=>255
    t.float    "x",                  :limit=>24
    t.float    "y",                  :limit=>24
    t.string   "color",              :limit=>255
    t.string   "image_file_name",    :limit=>255
    t.string   "image_content_type", :limit=>255
    t.integer  "image_file_size",    :limit=>4
    t.datetime "image_updated_at"
    t.boolean  "has_parent",         :default=>false
    t.boolean  "has_children",       :default=>false
  end

  create_table "adventurers", force: :cascade do |t|
    t.string   "name",       :limit=>40
    t.integer  "user_id",    :limit=>4, :index=>{:name=>"index_adventurers_on_user_id", :using=>:btree}, :foreign_key=>{:references=>"users", :name=>"fk_adventurers_user_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.integer  "skill",      :limit=>4
    t.integer  "energy",     :limit=>4
    t.integer  "luck",       :limit=>4
    t.integer  "gold",       :limit=>4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter_id", :limit=>4, :index=>{:name=>"fk_adventurers_chapter_id", :using=>:btree}, :foreign_key=>{:references=>"chapters", :name=>"fk_adventurers_chapter_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.integer  "story_id",   :limit=>4, :index=>{:name=>"fk_adventurers_story_id", :using=>:btree}, :foreign_key=>{:references=>"stories", :name=>"fk_adventurers_story_id", :on_update=>:restrict, :on_delete=>:restrict}
  end

  create_table "adventurer_chapters", force: :cascade do |t|
    t.integer  "adventurer_id", :limit=>4, :index=>{:name=>"fk_adventurer_chapters_adventurer_id", :using=>:btree}, :foreign_key=>{:references=>"adventurers", :name=>"fk_adventurer_chapters_adventurer_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.integer  "chapter_id",    :limit=>4, :index=>{:name=>"fk_adventurer_chapters_chapter_id", :using=>:btree}, :foreign_key=>{:references=>"chapters", :name=>"fk_adventurer_chapters_chapter_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: :cascade do |t|
    t.string   "name",        :limit=>40
    t.text     "description", :limit=>65535
    t.integer  "story_id",    :limit=>4, :index=>{:name=>"index_items_on_story_id", :using=>:btree}, :foreign_key=>{:references=>"stories", :name=>"fk_items_story_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "usable",      :default=>false
    t.string   "attr",        :limit=>255, :default=>""
    t.integer  "modifier",    :limit=>4, :default=>0
    t.string   "type",        :limit=>255, :default=>"UsableItem"
    t.integer  "damage",      :limit=>4, :default=>2
  end

  create_table "adventurers_items", force: :cascade do |t|
    t.integer  "adventurer_id", :limit=>4, :index=>{:name=>"index_adventurers_items_on_adventurer_id", :using=>:btree}, :foreign_key=>{:references=>"adventurers", :name=>"fk_adventurers_items_adventurer_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.integer  "item_id",       :limit=>4, :index=>{:name=>"index_adventurers_items_on_item_id", :using=>:btree}, :foreign_key=>{:references=>"items", :name=>"fk_adventurers_items_item_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",      :limit=>4, :default=>0
    t.boolean  "selected"
  end

  create_table "modifiers_shops", force: :cascade do |t|
    t.integer  "chapter_id", :limit=>4, :index=>{:name=>"fk_modifiers_shops_chapter_id", :using=>:btree}, :foreign_key=>{:references=>"chapters", :name=>"fk_modifiers_shops_chapter_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.integer  "item_id",    :limit=>4, :index=>{:name=>"fk_modifiers_shops_item_id", :using=>:btree}, :foreign_key=>{:references=>"items", :name=>"fk_modifiers_shops_item_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.integer  "price",      :limit=>4
    t.integer  "quantity",   :limit=>4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adventurers_shops", force: :cascade do |t|
    t.integer  "adventurer_id",    :limit=>4, :index=>{:name=>"fk_adventurers_shops_adventurer_id", :using=>:btree}, :foreign_key=>{:references=>"adventurers", :name=>"fk_adventurers_shops_adventurer_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.integer  "modifier_shop_id", :limit=>4, :index=>{:name=>"fk_adventurers_shops_modifier_shop_id", :using=>:btree}, :foreign_key=>{:references=>"modifiers_shops", :name=>"fk_adventurers_shops_modifier_shop_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.integer  "quantity",         :limit=>4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",    :limit=>4, :index=>{:name=>"fk_comments_user_id", :using=>:btree}, :foreign_key=>{:references=>"users", :name=>"fk_comments_user_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.integer  "story_id",   :limit=>4, :index=>{:name=>"fk_comments_story_id", :using=>:btree}, :foreign_key=>{:references=>"stories", :name=>"fk_comments_story_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.text     "content",    :limit=>65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "decisions", force: :cascade do |t|
    t.integer  "chapter_id",     :limit=>4, :index=>{:name=>"fk_decisions_chapter_id", :using=>:btree}, :foreign_key=>{:references=>"chapters", :name=>"fk_decisions_chapter_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.integer  "destiny_num",    :limit=>4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_validator", :limit=>4
  end

  create_table "favorite_stories", force: :cascade do |t|
    t.integer  "user_id",    :limit=>4, :index=>{:name=>"fk_favorite_stories_user_id", :using=>:btree}, :foreign_key=>{:references=>"users", :name=>"fk_favorite_stories_user_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.integer  "story_id",   :limit=>4, :index=>{:name=>"fk_favorite_stories_story_id", :using=>:btree}, :foreign_key=>{:references=>"stories", :name=>"fk_favorite_stories_story_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modifiers_attributes", force: :cascade do |t|
    t.integer  "chapter_id", :limit=>4, :index=>{:name=>"fk_modifiers_attributes_chapter_id", :using=>:btree}, :foreign_key=>{:references=>"chapters", :name=>"fk_modifiers_attributes_chapter_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.string   "attr",       :limit=>255
    t.integer  "quantity",   :limit=>4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modifiers_items", force: :cascade do |t|
    t.integer  "chapter_id", :limit=>4, :index=>{:name=>"fk_modifiers_items_chapter_id", :using=>:btree}, :foreign_key=>{:references=>"chapters", :name=>"fk_modifiers_items_chapter_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.integer  "item_id",    :limit=>4, :index=>{:name=>"fk_modifiers_items_item_id", :using=>:btree}, :foreign_key=>{:references=>"items", :name=>"fk_modifiers_items_item_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.integer  "quantity",   :limit=>4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monsters", force: :cascade do |t|
    t.string   "name",       :limit=>40
    t.integer  "skill",      :limit=>4
    t.integer  "energy",     :limit=>4
    t.integer  "chapter_id", :limit=>4, :index=>{:name=>"index_monsters_on_chapter_id", :using=>:btree}, :foreign_key=>{:references=>"chapters", :name=>"fk_monsters_chapter_id", :on_update=>:restrict, :on_delete=>:restrict}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130302125124) do

  create_table "account_statuses", :force => true do |t|
    t.integer  "account_id"
    t.date     "date"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
  end

  add_index "account_statuses", ["account_id", "year", "month"], :name => "index_account_statuses_on_account_id_and_year_and_month"

  create_table "accounts", :force => true do |t|
    t.string   "number"
    t.text     "name"
    t.integer  "bank_id"
    t.integer  "owner_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bank_summaries", :force => true do |t|
    t.date     "date"
    t.integer  "blocked_accounts"
    t.integer  "blocked_owners"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "bank_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
  end

  add_index "bank_summaries", ["bank_id", "year", "month"], :name => "index_bank_summaries_on_bank_id_and_year_and_month"

  create_table "banks", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "februar", :id => false, :force => true do |t|
    t.string "id"
    t.string "account"
    t.text   "name"
    t.string "bank"
  end

  create_table "januar", :id => false, :force => true do |t|
    t.string "id"
    t.string "account"
    t.text   "name"
    t.string "bank"
  end

  create_table "mart", :id => false, :force => true do |t|
    t.string "id"
    t.string "account"
    t.text   "name"
    t.string "bank"
  end

  create_table "owner_summaries", :force => true do |t|
    t.date     "date"
    t.integer  "blocked_accounts"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "owner_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
  end

  add_index "owner_summaries", ["owner_id", "year", "month"], :name => "index_owner_summaries_on_owner_id_and_year_and_month"

  create_table "owners", :force => true do |t|
    t.string   "oid"
    t.text     "name"
    t.string   "city"
    t.string   "address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.tsvector "full_text"
  end

  add_index "owners", ["full_text"], :name => "owners_full_text_idx", :index_type => :gin

end

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

ActiveRecord::Schema.define(version: 20150601131359) do

  create_table "locations", force: :cascade do |t|
    t.string   "locationID"
    t.float    "lattitude"
    t.float    "longitude"
    t.integer  "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "observations", force: :cascade do |t|
    t.datetime "updateTime"
    t.date     "updateDate"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "location_id"
  end

  add_index "observations", ["location_id"], name: "index_observations_on_location_id"

  create_table "predictions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regressions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weatherdata", force: :cascade do |t|
    t.float    "temperature"
    t.float    "precipitation"
    t.float    "windSpeed"
    t.string   "windDirectionS"
    t.string   "condition"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "observation_id"
  end

  add_index "weatherdata", ["observation_id"], name: "index_weatherdata_on_observation_id"

end

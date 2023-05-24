# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_05_23_111106) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_starters", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_starters_on_game_id"
    t.index ["player_id"], name: "index_game_starters_on_player_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "leader_id"
    t.date "date"
    t.string "opponent"
    t.boolean "game_won"
    t.integer "team_points"
    t.integer "opponent_points"
    t.integer "win"
    t.integer "loss"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "playoffs", default: false
    t.integer "year"
    t.index ["leader_id"], name: "index_games_on_leader_id"
    t.index ["team_id"], name: "index_games_on_team_id"
  end

  create_table "leaders", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "headshot_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "headshot_url"
    t.string "reference_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_leaders", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "leader_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leader_id"], name: "index_team_leaders_on_leader_id"
    t.index ["team_id"], name: "index_team_leaders_on_team_id"
  end

  create_table "team_players", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_team_players_on_player_id"
    t.index ["team_id"], name: "index_team_players_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year_start"
    t.integer "year_end"
  end

  add_foreign_key "game_starters", "games"
  add_foreign_key "game_starters", "players"
  add_foreign_key "team_leaders", "leaders"
  add_foreign_key "team_leaders", "teams"
  add_foreign_key "team_players", "players"
  add_foreign_key "team_players", "teams"
end

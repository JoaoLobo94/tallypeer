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

ActiveRecord::Schema[7.0].define(version: 2022_02_10_160154) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", null: false
    t.string "github", null: false
    t.string "private_key", null: false
    t.string "public_key", null: false
    t.integer "balance"
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
  end

  create_table "contributions", id: :integer, default: nil, force: :cascade do |t|
    t.string "pull_request", null: false
    t.string "type", null: false
    t.boolean "merged", default: false
    t.integer "balance"
    t.integer "vote_balance"
    t.integer "company_id", null: false
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
  end

  create_table "user_companies", id: :integer, default: nil, force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "user_id", null: false
  end

  create_table "user_contributions", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "contribution_id", null: false
    t.integer "balance"
  end

  create_table "users", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", null: false
    t.string "wallet_id", null: false
    t.string "job", null: false
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "contributions", "companies", name: "contributions_company_id_fkey"
  add_foreign_key "user_companies", "companies", name: "user_companies_company_id_fkey"
  add_foreign_key "user_companies", "users", name: "user_companies_user_id_fkey"
  add_foreign_key "user_contributions", "contributions", name: "user_contributions_contribution_id_fkey"
  add_foreign_key "user_contributions", "users", name: "user_contributions_user_id_fkey"
end

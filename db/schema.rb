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

ActiveRecord::Schema.define(version: 2021_12_19_155927) do

  create_table "repositories", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "github_id"
    t.string "name"
    t.string "full_name"
    t.string "link"
    t.string "language"
    t.datetime "repo_created_at"
    t.datetime "repo_updated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "hook_id"
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "repository_check_issues", force: :cascade do |t|
    t.text "message"
    t.text "rule_id"
    t.string "file_path"
    t.integer "line"
    t.integer "column"
    t.integer "check_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["check_id"], name: "index_repository_check_issues_on_check_id"
  end

  create_table "repository_checks", force: :cascade do |t|
    t.string "aasm_state"
    t.boolean "passed"
    t.string "commit_reference"
    t.integer "repository_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "language"
    t.index ["repository_id"], name: "index_repository_checks_on_repository_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "nickname"
    t.text "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "token_expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
  end

  add_foreign_key "repositories", "users"
  add_foreign_key "repository_check_issues", "repository_checks", column: "check_id"
  add_foreign_key "repository_checks", "repositories"
end

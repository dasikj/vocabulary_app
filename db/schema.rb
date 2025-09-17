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

ActiveRecord::Schema[7.2].define(version: 2025_09_17_101737) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sentence_taggings", force: :cascade do |t|
    t.bigint "sentence_id", null: false
    t.bigint "sentence_tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sentence_id", "sentence_tag_id"], name: "index_sentence_taggings_on_sentence_id_and_sentence_tag_id", unique: true
    t.index ["sentence_id"], name: "index_sentence_taggings_on_sentence_id"
    t.index ["sentence_tag_id"], name: "index_sentence_taggings_on_sentence_tag_id"
  end

  create_table "sentence_tags", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.index ["user_id", "name"], name: "index_sentence_tags_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_sentence_tags_on_user_id"
  end

  create_table "sentences", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id", null: false
    t.integer "sentence_category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "body"], name: "index_sentences_on_user_id_and_body", unique: true
    t.index ["user_id"], name: "index_sentences_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quiz_uses_count", default: 0, null: false
    t.integer "review_uses_count", default: 0, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vocabularies", force: :cascade do |t|
    t.string "word"
    t.string "reading"
    t.text "meaning"
    t.text "example"
    t.integer "part_of_speech"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "word"], name: "index_vocabularies_on_user_id_and_word", unique: true
    t.index ["user_id"], name: "index_vocabularies_on_user_id"
  end

  create_table "vocabulary_taggings", force: :cascade do |t|
    t.bigint "vocabulary_tag_id", null: false
    t.bigint "vocabulary_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vocabulary_id"], name: "index_vocabulary_taggings_on_vocabulary_id"
    t.index ["vocabulary_tag_id", "vocabulary_id"], name: "idx_on_vocabulary_tag_id_vocabulary_id_4486c456ca", unique: true
    t.index ["vocabulary_tag_id"], name: "index_vocabulary_taggings_on_vocabulary_tag_id"
  end

  create_table "vocabulary_tags", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.index ["user_id", "name"], name: "index_vocabulary_tags_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_vocabulary_tags_on_user_id"
  end

  add_foreign_key "sentence_taggings", "sentence_tags"
  add_foreign_key "sentence_taggings", "sentences"
  add_foreign_key "sentence_tags", "users"
  add_foreign_key "sentences", "users"
  add_foreign_key "vocabularies", "users"
  add_foreign_key "vocabulary_taggings", "vocabularies"
  add_foreign_key "vocabulary_taggings", "vocabulary_tags"
  add_foreign_key "vocabulary_tags", "users"
end

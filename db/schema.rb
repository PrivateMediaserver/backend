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

ActiveRecord::Schema[8.1].define(version: 2025_11_02_120155) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.uuid "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authentications", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "last_active_at", null: false
    t.uuid "refresh_uuid", null: false
    t.integer "status", default: 1, null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.uuid "user_id", null: false
    t.index ["refresh_uuid"], name: "index_authentications_on_refresh_uuid", unique: true
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "people", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["name"], name: "index_people_on_name", unique: true
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "screenshots", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "main", default: false, null: false
    t.datetime "updated_at", null: false
    t.uuid "video_id", null: false
    t.index ["video_id"], name: "index_screenshots_on_video_id"
    t.index ["video_id"], name: "index_screenshots_on_video_id_main_true", unique: true, where: "(main = true)"
  end

  create_table "tags", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["user_id", "name"], name: "index_tags_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "video_fragments", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "duration", null: false
    t.integer "sequence_number", null: false
    t.datetime "updated_at", null: false
    t.uuid "video_id", null: false
    t.index ["video_id", "sequence_number"], name: "index_video_fragments_on_video_id_and_sequence_number", unique: true
    t.index ["video_id"], name: "index_video_fragments_on_video_id"
  end

  create_table "video_people", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "person_id", null: false
    t.datetime "updated_at", null: false
    t.uuid "video_id", null: false
    t.index ["person_id"], name: "index_video_people_on_person_id"
    t.index ["video_id", "person_id"], name: "index_video_people_on_video_id_and_person_id", unique: true
    t.index ["video_id"], name: "index_video_people_on_video_id"
  end

  create_table "video_tags", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "tag_id", null: false
    t.datetime "updated_at", null: false
    t.uuid "video_id", null: false
    t.index ["tag_id"], name: "index_video_tags_on_tag_id"
    t.index ["video_id"], name: "index_video_tags_on_video_id"
  end

  create_table "videos", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "duration", default: 0.0, null: false
    t.jsonb "headers"
    t.integer "height"
    t.string "name", null: false
    t.float "progress", default: 0.0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.integer "width"
    t.index ["user_id"], name: "index_videos_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "authentications", "users"
  add_foreign_key "people", "users"
  add_foreign_key "screenshots", "videos"
  add_foreign_key "tags", "users"
  add_foreign_key "video_fragments", "videos"
  add_foreign_key "video_people", "people"
  add_foreign_key "video_people", "videos"
  add_foreign_key "video_tags", "tags"
  add_foreign_key "video_tags", "videos"
  add_foreign_key "videos", "users"
end

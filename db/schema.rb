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

ActiveRecord::Schema.define(version: 20161213235451) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "bookmarks", force: :cascade do |t|
    t.string   "bookmarkable_type", null: false
    t.integer  "bookmarkable_id",   null: false
    t.integer  "user_id",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["bookmarkable_type", "bookmarkable_id"], name: "index_bookmarks_on_bookmarkable_type_and_bookmarkable_id", using: :btree
    t.index ["user_id", "bookmarkable_type", "bookmarkable_id"], name: "unique_by_user_and_bookmarkable", unique: true, using: :btree
    t.index ["user_id"], name: "index_bookmarks_on_user_id", using: :btree
  end

  create_table "clinics", force: :cascade do |t|
    t.integer  "department_id", null: false
    t.string   "title",         null: false
    t.integer  "author_id",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_id"], name: "index_clinics_on_author_id", using: :btree
    t.index ["department_id"], name: "index_clinics_on_department_id", using: :btree
  end

  create_table "comment_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "comment_anc_desc_idx", unique: true, using: :btree
    t.index ["descendant_id"], name: "comment_desc_idx", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "thread_id",                         null: false
    t.integer  "author_id",                         null: false
    t.integer  "reply_to_id"
    t.string   "status",      default: "published", null: false
    t.text     "message",                           null: false
    t.boolean  "published",   default: true,        null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["author_id"], name: "index_comments_on_author_id", using: :btree
    t.index ["reply_to_id"], name: "index_comments_on_reply_to_id", using: :btree
    t.index ["thread_id"], name: "index_comments_on_thread_id", using: :btree
  end

  create_table "departments", force: :cascade do |t|
    t.integer  "hospital_id",         null: false
    t.string   "slug",                null: false
    t.string   "title",               null: false
    t.string   "director_name"
    t.string   "org_code"
    t.string   "department_page_url"
    t.string   "contact_phones",                   array: true
    t.integer  "number_of_patients"
    t.boolean  "published"
    t.integer  "creator_id",          null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["creator_id"], name: "index_departments_on_creator_id", using: :btree
    t.index ["hospital_id"], name: "index_departments_on_hospital_id", using: :btree
  end

  create_table "employees", force: :cascade do |t|
    t.integer  "clinic_id",                            null: false
    t.text     "biography"
    t.text     "biography_html"
    t.text     "notes"
    t.text     "notes_html"
    t.integer  "up_votes_count",   default: 0,         null: false
    t.integer  "down_votes_count", default: 0,         null: false
    t.string   "status",           default: "current", null: false
    t.integer  "author_id",                            null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.index ["author_id"], name: "index_employees_on_author_id", using: :btree
    t.index ["clinic_id"], name: "index_employees_on_clinic_id", using: :btree
  end

  create_table "hospitals", force: :cascade do |t|
    t.string   "slug",          null: false
    t.string   "name",          null: false
    t.citext   "acronym",       null: false
    t.string   "url"
    t.string   "street"
    t.string   "street_number"
    t.string   "city"
    t.string   "postal_code"
    t.string   "country_code"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["name", "acronym"], name: "index_hospitals_on_name_and_acronym", unique: true, using: :btree
    t.index ["slug"], name: "index_hospitals_on_slug", unique: true, using: :btree
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "qualifications", force: :cascade do |t|
    t.integer  "employee_id", null: false
    t.text     "name"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["employee_id"], name: "index_qualifications_on_employee_id", using: :btree
  end

  create_table "threads", force: :cascade do |t|
    t.string  "subject_type", null: false
    t.integer "subject_id",   null: false
    t.string  "title"
    t.index ["subject_type", "subject_id"], name: "index_threads_on_subject_type_and_subject_id", using: :btree
  end

  create_table "user_wards", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "ward_id", null: false
    t.index ["user_id"], name: "index_user_wards_on_user_id", using: :btree
    t.index ["ward_id"], name: "index_user_wards_on_ward_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.integer  "hospital_id"
    t.boolean  "admin",                  default: false, null: false
    t.string   "email",                                  null: false
    t.string   "nickname"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "locale",                 default: "en",  null: false
    t.decimal  "weight"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["hospital_id"], name: "index_users_on_hospital_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.string   "votable_type", null: false
    t.integer  "votable_id",   null: false
    t.integer  "user_id",      null: false
    t.string   "direction",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["direction"], name: "index_votes_on_direction", using: :btree
    t.index ["user_id", "votable_type", "votable_id"], name: "index_votes_on_user_id_and_votable_type_and_votable_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_votes_on_user_id", using: :btree
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id", using: :btree
  end

  create_table "wards", force: :cascade do |t|
    t.integer  "department_id",                    null: false
    t.string   "name",                             null: false
    t.boolean  "emergency",        default: false, null: false
    t.string   "url"
    t.string   "category"
    t.text     "description"
    t.integer  "up_votes_count",   default: 0,     null: false
    t.integer  "down_votes_count", default: 0,     null: false
    t.integer  "creator_id",                       null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["creator_id"], name: "index_wards_on_creator_id", using: :btree
    t.index ["department_id"], name: "index_wards_on_department_id", using: :btree
  end

  add_foreign_key "clinics", "departments"
  add_foreign_key "clinics", "users", column: "author_id"
  add_foreign_key "comments", "comments", column: "reply_to_id"
  add_foreign_key "comments", "threads"
  add_foreign_key "comments", "users", column: "author_id", on_update: :cascade
  add_foreign_key "departments", "hospitals"
  add_foreign_key "departments", "users", column: "creator_id"
  add_foreign_key "employees", "clinics"
  add_foreign_key "employees", "users", column: "author_id"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "qualifications", "employees", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_wards", "users"
  add_foreign_key "user_wards", "wards"
  add_foreign_key "users", "hospitals"
  add_foreign_key "wards", "departments"
  add_foreign_key "wards", "users", column: "creator_id"
end

# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101021090800) do

  create_table "account_sequences", :force => true do |t|
    t.integer "account_id", :limit => 8
    t.integer "project",                 :default => 1
  end

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "business_reqs", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "seq"
    t.integer  "project_id",        :limit => 8
    t.integer  "high_level_req_id", :limit => 8
    t.integer  "rule_id",           :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
    t.datetime "status_updated_at"
  end

  create_table "business_reqs_functional_reqs", :id => false, :force => true do |t|
    t.integer "business_req_id",   :limit => 8
    t.integer "functional_req_id", :limit => 8
  end

  create_table "business_reqs_non_functional_reqs", :id => false, :force => true do |t|
    t.integer "business_req_id",       :limit => 8
    t.integer "non_functional_req_id", :limit => 8
  end

  create_table "business_units", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "component_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "components", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "functional_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id",         :limit => 8
    t.string   "seq"
    t.integer  "stage_id",           :limit => 8
    t.integer  "component_type_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "functional_areas", :force => true do |t|
    t.text     "description"
    t.string   "name"
    t.integer  "project_id",  :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "seq"
    t.integer  "solution_id"
  end

  create_table "functional_reqs", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "seq"
    t.integer  "project_id",        :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
    t.datetime "status_updated_at"
  end

  create_table "high_level_reqs", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "seq"
    t.integer  "project_id",        :limit => 8
    t.integer  "rule_id",           :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
    t.datetime "status_updated_at"
    t.integer  "use_case_id",       :limit => 8
  end

  create_table "non_functional_reqs", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "seq"
    t.integer  "project_id",        :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
    t.datetime "status_updated_at"
  end

  create_table "project_sequences", :force => true do |t|
    t.integer "solution",                        :default => 1
    t.integer "component",                       :default => 1
    t.integer "functional_area",                 :default => 1
    t.integer "rule",                            :default => 1
    t.integer "high_level_req",                  :default => 1
    t.integer "functional_req",                  :default => 1
    t.integer "non_functional_req",              :default => 1
    t.integer "business_req",                    :default => 1
    t.integer "use_case",                        :default => 1
    t.integer "project_id",         :limit => 8
    t.integer "stage",                           :default => 1
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "start_on"
    t.date     "finish_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "seq"
    t.integer  "account_id",  :limit => 8
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "rule_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "rule_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rules", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "seq"
    t.integer  "rule_type_id"
    t.integer  "rule_status_id"
    t.integer  "project_id",        :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "component_id",      :limit => 8
    t.datetime "status_updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "solutions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "seq"
  end

  create_table "stages", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "project_id",  :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "seq"
  end

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "teams", :force => true do |t|
    t.integer  "business_unit_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "use_case_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "use_cases", :force => true do |t|
    t.integer  "project_id",        :limit => 8
    t.string   "name"
    t.text     "description"
    t.string   "seq"
    t.integer  "component_id",      :limit => 8
    t.integer  "status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "status_updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "encrypted_password"
    t.string   "password_salt"
    t.string   "confirmation_token",   :limit => 20
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token", :limit => 20
    t.string   "remember_token",       :limit => 20
    t.datetime "remember_created_at"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id",           :limit => 8
    t.string   "invitation_token",     :limit => 20
    t.datetime "invitation_sent_at"
    t.string   "name"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

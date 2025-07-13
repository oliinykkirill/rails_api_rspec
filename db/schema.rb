ActiveRecord::Schema[8.0].define(version: 2026_07_29_112000) do
  create_table "products", force: :cascade do |t|
    t.string "title"
    t.decimal "price"
    t.boolean "published"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "products", "users"
end

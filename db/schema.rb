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

ActiveRecord::Schema.define(version: 2019_04_06_101227) do

  create_table "bills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "bill_code", null: false
    t.integer "from_user_id", null: false
    t.integer "to_user_id", null: false
    t.string "description", null: false
    t.boolean "confirmed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id", "to_user_id"], name: "index_bills_on_from_user_id_and_to_user_id", unique: true
    t.index ["from_user_id"], name: "index_bills_on_from_user_id"
    t.index ["to_user_id"], name: "index_bills_on_to_user_id"
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "count", null: false
    t.float "price", null: false
    t.integer "ref_detail_id", null: false
    t.string "ref_detail_type", null: false
    t.bigint "product_warehouse_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_warehouse_id"], name: "index_details_on_product_warehouse_id"
  end

  create_table "images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "image", null: false
    t.integer "ref_image_id", null: false
    t.string "ref_image_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "content", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "partners", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "followed_id", null: false
    t.integer "follower_id", null: false
    t.integer "rank", null: false
    t.float "total_money", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id", "follower_id"], name: "index_partners_on_followed_id_and_follower_id", unique: true
    t.index ["followed_id"], name: "index_partners_on_followed_id"
    t.index ["follower_id"], name: "index_partners_on_follower_id"
  end

  create_table "product_warehouses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "count", null: false
    t.float "price_origin", null: false
    t.float "price_sale", null: false
    t.datetime "mfg", default: "2019-08-04 00:00:00"
    t.datetime "exp", default: "2019-08-04 00:00:00"
    t.boolean "stop_providing", default: false
    t.bigint "product_id", null: false
    t.bigint "warehouse_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_warehouses_on_product_id"
    t.index ["warehouse_id"], name: "index_product_warehouses_on_warehouse_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "product_code", null: false
    t.string "description", default: ""
    t.string "tag", default: ""
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "sells", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "sell_code", null: false
    t.integer "total_count", null: false
    t.float "total_price", null: false
    t.string "description", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sells_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "phone", default: "", null: false
    t.string "name", default: "", null: false
    t.boolean "gender"
    t.string "adress", default: ""
    t.date "birth", default: "2019-08-04"
    t.integer "role", default: 0, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "warehouses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "total_count", null: false
    t.float "total_money", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_warehouses_on_user_id"
  end

  add_foreign_key "details", "product_warehouses"
  add_foreign_key "notifications", "users"
  add_foreign_key "product_warehouses", "products"
  add_foreign_key "product_warehouses", "warehouses"
  add_foreign_key "products", "categories"
  add_foreign_key "sells", "users"
  add_foreign_key "warehouses", "users"
end

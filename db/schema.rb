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

ActiveRecord::Schema[8.0].define(version: 2024_12_01_124813) do
  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_customers_on_company_id"
  end

  create_table "document_items", force: :cascade do |t|
    t.integer "fiscal_document_id", null: false
    t.integer "product_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fiscal_document_id"], name: "index_document_items_on_fiscal_document_id"
    t.index ["product_id"], name: "index_document_items_on_product_id"
  end

  create_table "document_payments", force: :cascade do |t|
    t.integer "fiscal_document_id", null: false
    t.integer "payment_method_id", null: false
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fiscal_document_id"], name: "index_document_payments_on_fiscal_document_id"
    t.index ["payment_method_id"], name: "index_document_payments_on_payment_method_id"
  end

  create_table "fiscal_documents", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "fiscal_scenario_id", null: false
    t.text "description", null: false
    t.decimal "total_value"
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_fiscal_documents_on_company_id"
    t.index ["customer_id"], name: "index_fiscal_documents_on_customer_id"
    t.index ["fiscal_scenario_id"], name: "index_fiscal_documents_on_fiscal_scenario_id"
  end

  create_table "fiscal_scenarios", force: :cascade do |t|
    t.string "description"
    t.integer "operation"
    t.integer "operation_type"
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_fiscal_scenarios_on_company_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_payment_methods_on_company_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "cost_price"
    t.decimal "retail_price"
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_products_on_company_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.integer "role", default: 0, null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "customers", "companies"
  add_foreign_key "document_items", "fiscal_documents"
  add_foreign_key "document_items", "products"
  add_foreign_key "document_payments", "fiscal_documents"
  add_foreign_key "document_payments", "payment_methods"
  add_foreign_key "fiscal_documents", "companies"
  add_foreign_key "fiscal_documents", "customers"
  add_foreign_key "fiscal_documents", "fiscal_scenarios"
  add_foreign_key "fiscal_scenarios", "companies"
  add_foreign_key "payment_methods", "companies"
  add_foreign_key "products", "companies"
  add_foreign_key "sessions", "users"
  add_foreign_key "users", "companies"
end

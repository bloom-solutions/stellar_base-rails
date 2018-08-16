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

ActiveRecord::Schema.define(version: 20180816014433) do

  create_table "stellar_base_bridge_callbacks", force: :cascade do |t|
    t.string "operation_id", null: false
    t.string "from", null: false
    t.string "route"
    t.decimal "amount", null: false
    t.string "asset_code"
    t.string "asset_issuer"
    t.string "memo_type"
    t.string "memo"
    t.string "data"
    t.string "transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_code", "asset_issuer"], name: "index_stellar_base_bridge_callbacks_on_asset"
    t.index ["memo"], name: "index_stellar_base_bridge_callbacks_on_memo"
    t.index ["operation_id"], name: "index_stellar_base_bridge_callbacks_on_operation_id"
    t.index ["transaction_id"], name: "index_stellar_base_bridge_callbacks_on_transaction_id"
  end

end

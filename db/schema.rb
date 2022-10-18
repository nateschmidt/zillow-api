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

ActiveRecord::Schema[7.0].define(version: 2022_10_16_090638) do
  create_table "zillows", force: :cascade do |t|
    t.string "address"
    t.string "status"
    t.string "bedrooms"
    t.string "bathrooms"
    t.string "sqft"
    t.string "zestimate"
    t.string "rent_zestimate"
    t.string "property_type"
    t.string "year_built"
    t.string "heating"
    t.string "cooling"
    t.string "parking"
    t.string "lot"
    t.string "basement"
    t.string "flooring"
    t.string "appliances"
    t.string "fireplace"
    t.string "parking_feature"
    t.string "parcel_number"
    t.string "exterior_feature"
    t.string "construction_material"
    t.string "foundation"
    t.string "roof"
    t.string "region"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

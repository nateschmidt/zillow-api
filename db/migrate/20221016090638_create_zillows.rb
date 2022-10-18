class CreateZillows < ActiveRecord::Migration[7.0]
  def change
    create_table :zillows do |t|
      t.string :address
      t.string :status
      t.string :bedrooms
      t.string :bathrooms
      t.string :sqft
      t.string :zestimate
      t.string :rent_zestimate
      t.string :property_type
      t.string :year_built
      t.string :heating
      t.string :cooling
      t.string :parking
      t.string :lot
      t.string :basement
      t.string :flooring
      t.string :appliances
      t.string :fireplace
      t.string :parking_feature
      t.string :parcel_number
      t.string :exterior_feature
      t.string :construction_material
      t.string :foundation
      t.string :roof
      t.string :region

      t.timestamps
    end
  end
end

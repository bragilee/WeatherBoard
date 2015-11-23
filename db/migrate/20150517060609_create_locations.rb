class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :locationID
      t.float :lattitude
      t.float :longitude
      t.integer :postcode

      t.timestamps null: false
    end
  end
end

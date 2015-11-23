class CreateWeatherdata < ActiveRecord::Migration
  def change
    create_table :weatherdata do |t|
      t.float :temperature
      t.float :precipitation
      t.float :windSpeed
      t.string :windDirectionS
      t.integer :windDirectionD
      t.string :condition

      t.timestamps null: false
    end
  end
end

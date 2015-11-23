class AddLocationToObservation < ActiveRecord::Migration
  def change
    add_reference :observations, :location, index: true
    add_foreign_key :observations, :locations
  end
end

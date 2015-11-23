class AddObservationToWeatherdatum < ActiveRecord::Migration
  def change
    add_reference :weatherdata, :observation, index: true
    add_foreign_key :weatherdata, :observations
  end
end

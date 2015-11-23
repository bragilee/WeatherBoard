class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.datetime :updateTime
      t.date :updateDate

      t.timestamps null: false
    end
  end
end

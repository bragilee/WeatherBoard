class CreateRegressions < ActiveRecord::Migration
  def change
    create_table :regressions do |t|

      t.timestamps null: false
    end
  end
end

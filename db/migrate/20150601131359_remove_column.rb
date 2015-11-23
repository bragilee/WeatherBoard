class RemoveColumn < ActiveRecord::Migration
  def change
  	remove_column :weatherdata, :windDirectionD
  end
end

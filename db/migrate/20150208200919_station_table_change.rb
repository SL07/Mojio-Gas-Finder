class StationTableChange < ActiveRecord::Migration
  def change
    rename_column :stations, :name, :brand
  
    remove_column :stations, :long
    remove_column :stations, :lat
    remove_column :stations, :price
    remove_column :stations, :created_at
    remove_column :stations, :updated_at
  end
 
end

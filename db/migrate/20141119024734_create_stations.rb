class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :long
      t.string :lat
      t.string :price

      t.timestamps
    end
  end
end

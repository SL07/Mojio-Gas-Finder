class CreateStation < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.string :address
      t.string :city
      t.decimal :longitude
      t.decimal :latitude
      t.decimal :price
    end
    
    drop_table :widgets
  end
end

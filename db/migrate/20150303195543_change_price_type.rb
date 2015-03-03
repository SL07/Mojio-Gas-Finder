class ChangePriceType < ActiveRecord::Migration
  def change
    remove_column :stations, :unleaded
    remove_column :stations, :midGrade
    remove_column :stations, :premium
    remove_column :stations, :disel
    
    add_column :stations, :unleaded, :decimal, {:precision=>4, :scale=>2}
    add_column :stations, :midGrade, :decimal, {:precision=>4, :scale=>2}
    add_column :stations, :premium, :decimal, {:precision=>4, :scale=>2}
    add_column :stations, :diesel, :decimal, {:precision=>4, :scale=>2}
  end
end

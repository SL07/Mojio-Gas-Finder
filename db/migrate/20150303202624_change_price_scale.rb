class ChangePriceScale < ActiveRecord::Migration
  def change
    change_column :stations, :unleaded, :decimal, {:precision=>4, :scale=>2}
    change_column :stations, :midGrade, :decimal, {:precision=>4, :scale=>2}
    change_column :stations, :premium, :decimal, {:precision=>4, :scale=>2}
    change_column :stations, :diesel, :decimal, {:precision=>4, :scale=>2}
  end
end

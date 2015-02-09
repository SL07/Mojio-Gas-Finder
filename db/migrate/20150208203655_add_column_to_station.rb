class AddColumnToStation < ActiveRecord::Migration
  def change
    add_column :stations, :unleased, :string
    add_column :stations, :midGrade, :string
    add_column :stations, :premium, :string
    add_column :stations, :disel, :string
  end
end

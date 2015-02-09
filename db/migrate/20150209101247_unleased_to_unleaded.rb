class UnleasedToUnleaded < ActiveRecord::Migration
  def change
    rename_column :stations, :unleased, :unleaded
  end
end

class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.timestamp :timestamp

      t.timestamps
    end
  end
end

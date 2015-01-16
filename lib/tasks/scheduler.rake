desc "Heroku scheduler"

task :update_DB => :environment do
  def readCSV
    CSV.foreach('DB_data/day1.csv', :headers => true) do |row|
      Station.create!(row.to_hash)
    end
  end
end


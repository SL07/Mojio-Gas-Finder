require 'csv'
module StationsHelper
  def readCSV
    CSV.foreach('DB_data/day1.csv', :headers => true) do |row|
      Station.create!(row.to_hash)
    end
  end
module_function :readCSV
end

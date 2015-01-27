require 'csv'
module StationsHelper
  def readCSV
    CSV.foreach('DB_data/day1.csv', :headers => true) do |row|
      Station.create!(row.to_hash)
    end
  end

  def getStationAddressAll
    @stations = Station.select("address")    
    @stations.map(&:address).join "\n"
  end

module_function :readCSV
module_function :getStationAddressAll
end

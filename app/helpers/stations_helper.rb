require 'csv'

module StationsHelper
  def readCSV
    CSV.foreach('test.csv', :headers => true) do |row|
      Station.create!(row.to_hash)
    end	
  end
module_function :readCSV
end

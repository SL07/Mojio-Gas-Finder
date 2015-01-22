desc "Heroku scheduler"

require 'csv'

task :update_DB => :environment do
  CSV.foreach('DB_data/day1.csv', :headers => true) do |row|
    Station.create!(row.to_hash)
  end
end


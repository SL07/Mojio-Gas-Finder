desc "Heroku scheduler"

require "uri"
require 'net/http'
require 'nokogiri'

task :getStationsByCity => :environment do
  token = CGI::escape(opis_authentication())
  city = 'vancouver'
  state = 'bc'
  product = 'Unleaded'
  http = 'https://services.opisnet.com/RealtimePriceService/RealtimePriceService.asmx/GetCityStateSortedResults?UserTicket=' + token +'&City=' + city +'&State=' + state +'&SortByProduct=' + product
  http_response = http_get(http)
  http_response_nokogiri=Nokogiri::XML(http_response)
  namespaces = {
    'default' => 'https://services.opisnet.com/RealtimePriceService/',
    'diffgr' => 'urn:schemas-microsoft-com:xml-diffgram-v1'
  }
    
  nokogiri_NodeSet_station = http_response_nokogiri.xpath('//default:StationPricesDataTable/diffgr:diffgram/DocumentElement/StationPrices', namespaces)
    
  index = 0
  nokogiri_NodeSet_station.each do |station_element|
    nodeSet_address = station_element.xpath('//Address1')
    nodeSet_city = station_element.xpath('//City')
    nodeSet_brand = station_element.xpath('//Brand_Name')
    nodeSet_unleaded = station_element.xpath('//Unleaded_Price')
    nodeSet_midGrade = station_element.xpath('//MidGrade_Price')
    nodeSet_premium = station_element.xpath('//Premium_Price')
    nodeSet_diesel = station_element.xpath('//Diesel_Price')
      
    if nodeSet_address[index] == nil
      address = nil
    else 
      address = nodeSet_address[index].content
    end

    if nodeSet_city[index] == nil
      city = nil
    else 
      city = nodeSet_city[index].content
    end

    if nodeSet_brand[index] == nil
      brand = nil
    else 
      brand = nodeSet_brand[index].content
    end

    if nodeSet_unleaded[index] == nil
      unleaded = nil
    else 
      unleaded = nodeSet_unleaded[index].content
    end

    if nodeSet_midGrade[index] == nil
      midGrade = nil
    else 
      midGrade = nodeSet_midGrade[index].content
    end

    if nodeSet_premium[index] == nil
      premium = nil
    else 
      premium = nodeSet_premium[index].content
    end

    if nodeSet_diesel[index] == nil
      diesel = nil
    else 
      disel = nodeSet_diesel[index].content
    end

    Station.create(:brand => brand, :address => address, :city => city, :unleaded => unleaded, :midGrade => midGrade, :premium => premium, :diesel => disel) 
      index = index + 1
  end
    
  updatedTime = Time.zone.now
  Job.create(:timestamp => updatedTime)
end    

def http_get(link)
  url = URI.parse(link)
  req = Net::HTTP::Get.new(url.request_uri)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = (url.scheme == "https")
  http_response = http.request(req)
  http_response_xml = http_response.body
  return http_response_xml
end
  
def opis_authentication
  key = 'ytSw2WGNsn8FUIgEdrgbYQ=='
  http= 'https://services.opisnet.com/RealtimePriceService/RealtimePriceService.asmx/Authenticate?CustomerToken=' + key
  http_response = http_get(http)
  http_response_nokogiri=Nokogiri::XML(http_response)
  nokogiri_NodeSet= http_response_nokogiri.xpath('//foo:string', 'foo' => 'https://services.opisnet.com/RealtimePriceService/')
  token=nokogiri_NodeSet[0].content

  return token
end
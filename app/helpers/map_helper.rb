require "uri"
require 'net/http'
require 'nokogiri'

module MapHelper

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

  def convertKmtoMile(km)
    mile = km * 0.621371
    return mile
  end

  def getCheapestStation(longitude, latitude, sortByProduct, distance_km)
    token = CGI::escape(opis_authentication())
    latitude = '49.2778920'
    longitude = '-123.1267770'
    sortByProduct = 'Premium'
    distance_mile = convertKmtoMile(distance_km).to_s
    isFilteredByDistance = true
    userLatitude = latitude
    userLongitude = longitude
    http = 'https://services.opisnet.com/RealtimePriceService/RealtimePriceService.asmx/GetLatLongSortedWithDistanceResults?UserTicket=' + token + '&Latitude=' + latitude + '&Longitude=' + longitude + '&SortByProduct=' + sortByProduct + '&distance=' + distance_mile + '&isFilteredByDistance=' + isFilteredByDistance.to_s + '&UserLatitude=' + userLatitude + '&UserLongitude=' + userLongitude

    http_response = http_get(http)
    http_response_nokogiri=Nokogiri::XML(http_response)
    
    namespaces = {
      'default' => 'https://services.opisnet.com/RealtimePriceService/',
      'diffgr' => 'urn:schemas-microsoft-com:xml-diffgram-v1'
    }
    
     nokogiri_NodeSet_station = http_response_nokogiri.xpath('//default:StationPricesByLatLongDataTable/diffgr:diffgram/DocumentElement/StationPricesByLatLong', namespaces)

    #return http_response
    #return nokogiri_NodeSet_station[0].content
    #return nokogiri_NodeSet_station.length
  end

module_function :http_get
module_function :opis_authentication
module_function :convertKmtoMile
module_function :getCheapestStation

end

require "uri"
require 'net/http'
require 'nokogiri'

class MapController < ApplicationController

  def getClosest
    longitude = params[:longitude_input]
    latitude = params[:latitude_input]
    product = params[:product_input]
 
    station_NodeSet = getStation(longitude, latitude, product, 10)
    
    current_index = 0
    closestStation_index = 0
    min_distance = 99
   
    address = station_NodeSet.xpath('//Address1') 
    city = station_NodeSet.xpath('//City')
    brand = station_NodeSet.xpath('//Brand_Name')
    distance = station_NodeSet.xpath('//distancetostation')
        
    product = product
    if product == 'Unleaded'
      price = station_NodeSet.xpath('//Unleaded_Price')
    elsif product == 'Midgrade'
      price = station_NodeSet.xpath('//MidGrade_Price')
    elsif product == 'Premium'
      price = station_NodeSet.xpath('//Premium_Price')
    elsif product == 'Diesel'
      price = station_NodeSet.xpath('//Diesel_Price')
    end
    
    if address.length == 0
      render :json => {
        :brand_out => 'No Result Found',
        :address_out => 'No Result Found', 
        :distance_out => 'No Result Found',
        :product_out => product,
        :price_out => 'No Result Found'
    }
    else  
      while current_index < distance.length
        if distance[current_index].content.to_f < min_distance.to_f
          min_distance = distance[current_index].content
          closestStation_index = current_index
        end
        current_index = current_index + 1
      end

      address_display = address[closestStation_index].content + ', ' + city[closestStation_index].content
      distance_display =  '%.2f'% convertMiletoKm(distance[closestStation_index].content.to_f)
      price_display =  '%.3f'% price[closestStation_index].content

      render :json => {
        :brand_out => brand[closestStation_index].content,
        :address_out => address_display,
        :distance_out => distance_display,
        :product_out => product,
        :price_out => price_display
      }
    end
  end

  def getCheapest
    longitude = params[:longitude_input]
    latitude = params[:latitude_input]
    product = params[:product_input]
    distance = params[:distance_input]
    
    station_NodeSet = getStation(longitude, latitude, product, distance)

    address = station_NodeSet.xpath('//Address1') 
    city = station_NodeSet.xpath('//City')
    brand = station_NodeSet.xpath('//Brand_Name')
    distance = station_NodeSet.xpath('//distancetostation')
        
    if product == 'Unleaded'
      price = station_NodeSet.xpath('//Unleaded_Price')
    elsif product == 'Midgrade'
      price = station_NodeSet.xpath('//MidGrade_Price')
    elsif product == 'Premium'
      price = station_NodeSet.xpath('//Premium_Price')
    elsif product == 'Diesel'
      price = station_NodeSet.xpath('//Diesel_Price')
    end

    if address.length == 0
      render :json => {
        :brand_out => 'No Result Found',
        :address_out => 'No Result Found', 
        :distance_out => 'No Result Found',
        :product_out => product,
        :price_out => 'No Result Found'
    }
    else
      address_display = address[0].content + ', ' + city[0].content
      distance_display =  '%.2f'% convertMiletoKm(distance[0].content.to_f)
      price_display =  '%.3f'% price[0].content

      render :json => {
        :brand_out => brand[0].content,
        :address_out => address_display,
        :distance_out => distance_display,
         :product_out => product,
        :price_out => price_display
      }
   end 
  end
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

  def convertKmtoMile(km)
    mile = km * 0.621371
    return mile
  end

  def convertMiletoKm(mile)
    km = mile * 1.60934
    return km
  end

  def getStation(longitude, latitude, sortByProduct, distance_km)
    token = CGI::escape(opis_authentication())
    distance_mile = convertKmtoMile(distance_km.to_f).to_s
    isFilteredByDistance = 'true'
    
    http = 'https://services.opisnet.com/RealtimePriceService/RealtimePriceService.asmx/GetLatLongSortedWithDistanceResults?UserTicket=' + token + '&Latitude=' + latitude + '&Longitude=' + longitude + '&SortByProduct=' + sortByProduct +'&distance=' + distance_mile + '&isFilteredByDistance=' + isFilteredByDistance + '&UserLatitude=' + latitude + '&UserLongitude=' + longitude 

    http_response = http_get(http)
    http_response_nokogiri=Nokogiri::XML(http_response)
   
    namespaces = {
      'default' => 'https://services.opisnet.com/RealtimePriceService/',
      'diffgr' => 'urn:schemas-microsoft-com:xml-diffgram-v1'
    }
    
    nokogiri_NodeSet_station = http_response_nokogiri.xpath('//default:StationPricesByLatLongDataTable/diffgr:diffgram/DocumentElement/StationPricesByLatLong', namespaces)
        
    return nokogiri_NodeSet_station
  end

 
  


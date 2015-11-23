require 'nokogiri'
require 'open-uri'
require 'json'
require 'date'

class Location < ActiveRecord::Base
  has_many :observations
  #The "self.update" mthod is used to update the Location.model.
  def self.update (fetched_data)
    a=[]
    i=0
    fetched_data.each do |key,record|
      latlong=record["observations"]["data"][0]["lat"].to_s+","+record["observations"]["data"][0]["lon"].to_s
      location_info = JSON.parse(open("http://maps.googleapis.com/maps/api/geocode/json?latlng=#{latlong}&sensor=true").read)
      postcode=0
      sub_hash = location_info["results"][0]
      if (sub_hash!=nil)
       
        sub_hash["address_components"].each do |sub|
          if (sub["types"] == ["postal_code"])
            postcode = sub["long_name"]
          end
        end
      end


      Location.create(:locationID=> record["observations"]["header"][0]["name"], 
        :lattitude=>record["observations"]["data"][0]["lat"].to_f, 
        :longitude=>record["observations"]["data"][0]["lon"].to_f, 
        :postcode=>postcode.to_i)
    end
  end

  # The "self.getLoctions" is the first API, it can returns the realted information of locations.
  def self.getLocations
    h = Hash.new
    d = Date.today
    h.store("date",d)
    location_array = []
    locations = Location.all
    locations.each do |l|
      sub_hash = Hash.new
      t = Observation.where(location_id: l.id).last.updateTime
      sub_hash = {"id"=>l.locationID, "lat"=>l.lattitude, "lon"=>l.longitude, "last_update"=>t.to_time}
      location_array << sub_hash
    end
    h.store("locations", location_array)
    return h
  end

  #The "self.getData" is the used to get all the weather data from BOM.
  def self.getData
    url = 'http://www.bom.gov.au/vic/observations/vicall.shtml'
    
    doc = Nokogiri::HTML(open(url))
    content = doc.css('tbody .rowleftcolumn')
    dataHash=Hash.new

    content.css('th').each do |site|
      site_link=site.css('a')[0]['href']
      site_url="http://www.bom.gov.au/#{site_link}"
      doc = Nokogiri::HTML(open(site_url))
      jsondoc = doc.css('a').select{|link|(link['href']=~/\.json/)!=nil}
      json_url="http://www.bom.gov.au/#{jsondoc[0]['href']}"
      location_weather = JSON.parse(open(json_url).read)
      dataHash.store("#{location_weather["observations"]["header"][0]["name"]}",location_weather)
      
    end
      
    return dataHash
  end
  # The "self.getRealiableData" is to select weather data that can be used in our system.
  def self.getReliableData dataHash
    rdataHash=Hash.new
    dataHash.each do |key,record|
      i=0
      ["rain_trace","air_temp","wind_spd_kmh","wind_dir"].each do |dt|
        d=record["observations"]["data"][0][dt]
        if (d!=nil)&&(d!="-")&&(d!="")
          i+=1
        end
      end

      data_amou=record["observations"]["data"].count
      if (i==4)&&(data_amou>140)&&(data_amou<150)
        rdataHash.store(key,record)
      end
    end
    return rdataHash
  end

  # The "self.getDatabyLocation" is the second API to get the measurements of a certain locationID and date.
  def self.getDataByLocation(locationID, date)
    h = Hash.new
    date = date.to_date
    h.store("date",date)
    location = Location.find_by(locationID:locationID)
    if(location==nil)
      h.store("measurements", [])
      return h
    else
      temp = Observation.getCurrTemp(location.id)
      h.store("current_temp",temp)
      cond = Observation.getCurrCond(location.id)
      h.store("current_cond",cond)
      m_array = Observation.getMeasurements(location.id, date)
      h.store("measurements", m_array)
      return h
    end
  end

   # The "self.getDataByPostcode" is the thrid API to get the measurements of certain postcode and date.
  def self.getDataByPostcode(postcode, date)
    date = date.to_date
    h = Hash.new
    h.store("date",date)
    locations = Location.where(postcode:postcode)
    if(locations == nil)
      h.store("locations", [])
    else
      location_array = []
      locations.each do |l|
        sub_hash = Hash.new
        t = Observation.where(location_id: l.id).last.updateTime
        m_array = Observation.getMeasurements(l.id, date)
        sub_hash = {"id"=>l.locationID, "lat"=>l.lattitude, "lon"=>l.longitude, "last_update"=>t.to_time, "measurements"=>m_array}
        location_array << sub_hash
      end
      h.store("locations", location_array)
    end
    return h
  end

end

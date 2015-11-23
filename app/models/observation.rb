require 'json'
require 'date'
require 'open-uri'

class Observation < ActiveRecord::Base
	belongs_to :location
	has_one :weatherdatum
	# the "self.updateData" is used to update all the database.
	def self.updateData

		dataHash=Location.getData
		rdataHash=Location.getReliableData(dataHash)

		if(Location.all.length == 0)
     		Location.update(rdataHash)
  		end
	
  		locations = Location.all

    	locations.each do |l|
    		data=dataHash["#{l.locationID}"]["observations"]["data"]
    		size=data.size
    		for i in (0..size-2)
    			j=0
    			l.observations.each do |o|
    				if data[i]["local_date_time_full"].to_time==o.updateTime
    					j+=1
    				end
    			end

    			if j==0
    				if data[i]["local_date_time_full"][-6..-3]=="0930"
    					rain=data[i]["rain_trace"].to_f
    				else
    					rain=data[i]["rain_trace"].to_f-data[i+1]["rain_trace"].to_f
    				end

    				con=getCondition(data[i])
    				oRecord=Observation.create(:updateTime=>data[i]["local_date_time_full"].to_time,
    					:updateDate=>data[i]["local_date_time_full"].to_time.to_date,:location_id=>l.id)
    				Weatherdatum.create(:condition=>con,:temperature=>data[i]["air_temp"],:precipitation=>rain.round(2),
    					:windSpeed=>data[i]["wind_spd_kmh"],:windDirectionS=>data[i]["wind_dir"],:observation_id=>oRecord.id)
    			end
    		end

       	end
    end
    # The "self.getCondition" is to give a overal description of one data record.
    def self.getCondition dataHash
    	
    	if dataHash["rain_trace"].to_f>0
    		return "Rainy"
    	else
    		return "Sunny"
    	end
    end
    #The "self.getCurrTemp" is to get the current temperatuue of a location_id.
 	def self.getCurrTemp(location_id)
		t = Observation.where(location_id: location_id).last.updateTime
		
		if((Time.now-t)<30*60)
			temp_id = Observation.find_by(location_id: location_id, updatetime: t).id
			temp = Weatherdatum.find_by(observation_id:temp_id).temperature
		else
		    temp = nil
		end
		return temp
	end
	#The "self.getMeasurements" is to get the measures of a certain location_id and a date.
  	def self.getMeasurements(location_id, date)
	    date = date.to_date
	    h = Hash.new
	    records_t = self.where(location_id: location_id, updateDate: date)

	    time_arrary = []
	    temp_arrary = []
	    precip_arrary = []
		wind_spe_array = []
		wind_dir_array=[]

	    records_t.each do |r|
	      time_arrary << r.updateTime
	      temp_arrary << r.weatherdatum.temperature
	      precip_arrary << r.weatherdatum.precipitation
	      wind_spe_array << r.weatherdatum.windSpeed
	      wind_dir_array << r.weatherdatum.windDirectionS
	    end

	    m_array = []
	    (0..(time_arrary.length-1)).each do |i|
	      sh = Hash.new
	      sh = {"time" => time_arrary[i].to_time, "temp" => temp_arrary[i], "precip" => precip_arrary[i], "wind_direction" => wind_dir_array[i], "wind_speed" => wind_spe_array[i] }
	      m_array << sh
	    end

	    return m_array
  	end
  	# The "self.getCurrCond" is to get the current condition of a location_id.
  	def self.getCurrCond(location_id)
	    t = Observation.where(location_id: location_id).last.updateTime
	    return Observation.find_by(location_id: location_id, updateTime: t).weatherdatum.condition
	end
	# The "self.getPreData" is to get the data for a time and locationID to make prediction.
	def self.getPreData(now,locationID)
		start=now-24*60*60
		observations=Location.find_by(locationID:locationID).observations.where("updateTime >=:s AND updateTime<:n",{s:start,n:now})
		
		preData=Hash.new

		time_arrary=[]
		temp_arrary=[]
		wind_spe_array=[]
		wind_dir_array=[]
		precip_arrary=[]
		
		observations.each do |o|
			time_arrary<<o.updateTime.to_i
			temp_arrary<<o.weatherdatum.temperature
			wind_spe_array<<o.weatherdatum.windSpeed
			wind_dir_array<<o.weatherdatum.windDirectionS
			precip_arrary<<o.weatherdatum.precipitation
		end

		return preData={:time=>time_arrary,:temp=>temp_arrary,:windSpe=>wind_spe_array,:windDir=>wind_dir_array,:precip=>precip_arrary}
	end

end


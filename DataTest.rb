	require 'nokogiri'
	require 'open-uri'
	require 'json'
	

	url = 'http://www.bom.gov.au/vic/observations/vicall.shtml'
	
	doc = Nokogiri::HTML(open(url))
	content = doc.css('tbody .rowleftcolumn')
	i = 0
	data_array=[]

	content.css('th').each do |site|
		site_link=site.css('a')[0]['href']
		site_url="http://www.bom.gov.au/#{site_link}"
		doc = Nokogiri::HTML(open(site_url))
		jsondoc = doc.css('a').select{|link|(link['href']=~/\.json/)!=nil}
		json_url="http://www.bom.gov.au/#{jsondoc[0]['href']}"
		location_weather = JSON.parse(open(json_url).read)
		i=0
		["rain_trace","air_temp","wind_spd_kmh","wind_dir"].each do |dt|
			d=location_weather["observations"]["data"][0][dt]
			if (d!=nil)&&(d!="-")&&(d!="")
				i+=1
			end
		end

		data_amou=location_weather["observations"]["data"].count
		if ((i==4)
			# &&(data_amou>100)&&(data_amou<160))
			data_array<<location_weather
		end
	end

	
	
	# site_content = site_doc.css('.stationdetails').css('tr').css('td')
	
	
	# location_lat[i] = (site_content[3].text[/[0-9.-]+/])
	# location_lon[i] = (site_content[4].text[/[0-9.-]+/])
	
	#   location_coor[i] = location_lat[i] + "," + location_lon[i]
	#   sub_hash["coordinate"] = location_coor[i]
	#   location_info = JSON.parse(open("http://maps.googleapis.com/maps/api/geocode/json?latlng=#{location_coor[i]}&sensor=true_or_false").read)
	#   sub_array = location_info["results"][0]["address_components"]
	
	#   sub_array.each do |sub|
	#     if (sub["types"] == ["postal_code"])
	#       sub_hash["postcode"] = sub["long_name"]
	#       sub_hash["lattitude"] = location_lat[i]
	#       sub_hash["longitude"] = location_lon[i]
	#       location_hash[name] = sub_hash
	#     end
	#   end
	#   i = i+1
	# end
	
require 'nokogiri'
require 'open-uri'

url='http://www.bom.gov.au//products/IDV60801/IDV60801.94839.shtml'
doc = Nokogiri::HTML(open(url))
jsondoc = doc.css('a').select do |link|
	(link['href']=~/\.json/)!=nil
end
puts jsondoc[0]['href']
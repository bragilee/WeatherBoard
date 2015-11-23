class DataController < ApplicationController
  def showLocation
    Observation.updateData
  	@location_data = Location.getDataByLocation(params[:location_id],params[:date])
  	respond_to do |format|
		format.html 
  		format.json { render json: @location_data }  
  	end
  end

  def showPostcode
    Observation.updateData
  	@postcode_data = Location.getDataByPostcode(params[:postcode],params[:date])
  	respond_to do |format|
		format.html 
  		format.json { render json: @postcode_data }  
  	end
  end
end

require 'date'
class LocationController < ApplicationController
  def showLocations
  	Observation.updateData
    @locations = Location.getLocations
    respond_to do |format|
		format.html 
  		format.json { render json: @locations }  
  	end
  end
end

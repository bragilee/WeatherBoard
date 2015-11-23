class PredictionController < ApplicationController
  def showLatLong
  Observation.updateData
	@prediction_lat_lon = Prediction.getPredictionByLatLong(params[:lat],params[:long],params[:period])
  	respond_to do |format|
		format.html 
  		format.json { render json: @prediction_lat_lon }  
  	end
  end

  def showPostcode
    Observation.updateData
  	@prediction_postcode = Prediction.getPredictionByPostcode(params[:postcode],params[:period])
  	respond_to do |format|
		format.html 
  		format.json { render json: @prediction_postcode }  
  	end
  end
end

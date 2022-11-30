class Api::BarangaysController < ApplicationController
  def index
    city_municipalities = Address::CityMunicipality.find(params[:city_municipality_id])
    barangays = city_municipalities.barangays
    render json: barangays, each_serializer: BarangaySerializer
  end
end

class CityMunicipalitySerializer < ActiveModel::Serializer
  attributes :id, :name

  def province
    object.province.name
  end
end

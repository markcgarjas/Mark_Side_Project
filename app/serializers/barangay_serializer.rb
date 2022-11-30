class BarangaySerializer < ActiveModel::Serializer
  attributes :id, :name

  def city_municipality
    object.city_municipality.name
  end
end

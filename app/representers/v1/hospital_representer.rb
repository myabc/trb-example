class V1::HospitalRepresenter < V1::BaseRepresenter
  self.representation_wrap = :hospital

  property :id
  property :self_url, exec_context: :decorator
  property :slug

  property :name
  property :acronym
  property :country_code
  property :city
  property :postal_code
  property :street
  property :street_number

  property :updated_at

  property :url

  private

  def self_url
    api_v1_hospital_url(represented, only_path: true) if represented.id
  end
end

class V1::ClinicsRepresenter < V1::CollectionRepresenter
  self.representation_wrap = :clinics
  items extend: ::V1::ClinicRepresenter, class: Clinic, wrap: false
end

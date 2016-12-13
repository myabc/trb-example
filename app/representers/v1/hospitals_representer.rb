class V1::HospitalsRepresenter < V1::CollectionRepresenter
  self.representation_wrap = :hospitals
  items extend: ::V1::HospitalRepresenter, class: Hospital, wrap: false
end

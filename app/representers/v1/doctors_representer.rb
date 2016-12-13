class V1::DoctorsRepresenter < V1::CollectionRepresenter
  self.representation_wrap = :doctors
  items extend: ::V1::DoctorRepresenter, class: Doctor, wrap: false
end

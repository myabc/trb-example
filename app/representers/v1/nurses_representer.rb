class V1::NursesRepresenter < V1::CollectionRepresenter
  self.representation_wrap = :nurses
  items extend: ::V1::NurseRepresenter, class: Nurse, wrap: false
end

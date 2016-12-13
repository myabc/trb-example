class V1::WardsRepresenter < V1::CollectionRepresenter
  self.representation_wrap = :wards
  items extend: ::V1::WardRepresenter,
        class:  Ward,
        wrap:   false
end

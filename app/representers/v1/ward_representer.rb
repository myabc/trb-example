class V1::WardRepresenter < V1::BaseRepresenter
  self.representation_wrap = :ward

  with_options writeable: false do
    property :id
    property :up_votes_count
    property :created_at
    property :updated_at
  end

  property :department_id
  property :creator_id
  property :name
  property :url
  property :description
  property :category
  property :emergency
end

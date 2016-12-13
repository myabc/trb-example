class V1::EmployeeRepresenter < V1::BaseRepresenter
  with_options writeable: false do
    property :id
    property :author_id

    property :clinic_id

    property :up_votes_count,   as: :upvotes_count
    property :down_votes_count, as: :downvotes_count
    property :updated_at
    property :created_at

    property :status
  end

  module CreatePrivileged
    include Representable::JSON

    property :status
  end

  module UpdatePrivileged
    include Representable::JSON
    include CreatePrivileged

    property :author_id
    property :clinic_id
  end
end

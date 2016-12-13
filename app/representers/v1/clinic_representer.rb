class V1::ClinicRepresenter < V1::BaseRepresenter
  self.representation_wrap = :clinic

  with_options writeable: false do
    property :id
    property :updated_at
    property :department_id
    property :author_id

    property :updated_at

    collection :doctors, extend: ::V1::DoctorRepresenter,
                         wrap: false,
                         if: ->(options:, **) {
                               options.fetch(:wrap, true)
                             }

    collection :nurses, extend: ::V1::NurseRepresenter,
                        wrap: false,
                        if: ->(options:, **) {
                              options.fetch(:wrap, true)
                            }
  end

  property :title
end

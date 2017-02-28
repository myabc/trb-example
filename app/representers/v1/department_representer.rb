class V1::DepartmentRepresenter < V1::BaseRepresenter
  self.representation_wrap = :department

  HTML_URL_TEMPLATE = URITemplate.new('https://gotrailblazer.com/department/{department}')

  with_options writeable: false do
    property :creator_id

    property :id
    property :self_url, exec_context: :decorator
    property :slug

    property :hospital_id

    property :published

    property :updated_at

    collection :doctors, extend: ::V1::DoctorRepresenter,
                         wrap: false,
                         if: ->(options:, user_options:, **) {
                               options.fetch(:wrap, true) &&
                                 (user_options || {}).fetch(:includes, [])
                                                     .include?('doctors')
                             }

    collection :nurses, extend: ::V1::NurseRepresenter,
                        wrap: false,
                        if: ->(options:, user_options:, **) {
                              options.fetch(:wrap, true) &&
                                (user_options || {}).fetch(:includes, [])
                                                    .include?('nurses')
                            }
  end

  collection :clinics, extend: ::V1::ClinicRepresenter,
                       wrap: false,
                       populator: Reform::Form::Populator::External.new,
                       if: ->(options:, **) { options.fetch(:wrap, true) }

  property :contact_phones

  property :title
  property :org_code
  property :director_name

  module CreatePrivileged
    include Representable::JSON

    property :published
  end

  module UpdatePrivileged
    include Representable::JSON
    include CreatePrivileged

    property :hospital_id
  end

  def self_url
    api_v1_department_url(represented, only_path: true) if represented.id
  end
end

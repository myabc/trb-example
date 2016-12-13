class V1::NurseRepresenter < V1::EmployeeRepresenter
  self.representation_wrap = :nurse

  property :notes
  property :notes_html

  with_options writeable: false do
    property :updated_at
  end

  collection :qualifications, class: Qualification,
                              populator: Reform::Form::Populator::External.new do
    defaults render_nil: true

    property :id
    property :name
    property :position
  end
end

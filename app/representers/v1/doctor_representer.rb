class V1::DoctorRepresenter < V1::EmployeeRepresenter
  self.representation_wrap = :doctor

  property :biography
  property :notes
  property :biography_html
  property :notes_html
end

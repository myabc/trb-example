class V1::DepartmentsRepresenter < V1::CollectionRepresenter
  self.representation_wrap = :departments
  items extend: ::V1::DepartmentRepresenter, class: Department, wrap: false
end

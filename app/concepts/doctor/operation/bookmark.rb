require_dependency 'employee/operation/bookmark'

class Doctor::Bookmark < ::Employee::Bookmark
  model  Doctor, :find
  policy DoctorPolicy, :bookmark?
end

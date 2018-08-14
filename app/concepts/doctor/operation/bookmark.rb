require_dependency 'employee/operation/bookmark'

class Doctor::Bookmark < ::Employee::Bookmark
  step Model(Doctor, :find)
  step Policy::Pundit(DoctorPolicy, :bookmark?)
  step :process
end

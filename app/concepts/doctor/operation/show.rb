require_dependency 'employee/operation/show'

class Doctor::Show < ::Employee::Show
  step Model(Doctor, :find)
  step Policy::Pundit(DoctorPolicy, :show?)

  representer :serializer, V1::DoctorRepresenter
end

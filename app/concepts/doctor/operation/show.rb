require_dependency 'employee/operation/show'

class Doctor::Show < ::Employee::Show
  step Model(Doctor, :find)
  step Policy::Pundit(DoctorPolicy, :show?)

  representer :render, V1::DoctorRepresenter
end

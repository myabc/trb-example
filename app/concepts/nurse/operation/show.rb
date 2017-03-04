require_dependency 'employee/operation/show'

class Nurse::Show < ::Employee::Show
  step Model(Nurse, :find)
  step Policy::Pundit(NursePolicy, :show?)

  representer :serializer, V1::NurseRepresenter
end

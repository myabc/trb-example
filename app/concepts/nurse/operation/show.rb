require_dependency 'employee/operation/show'

class Nurse::Show < ::Employee::Show
  step Model(Nurse, :find)
  step Policy::Pundit(NursePolicy, :show?)

  representer :render, V1::NurseRepresenter
end

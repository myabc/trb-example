require_dependency 'employee/operation/bookmark'

class Nurse::Bookmark < ::Employee::Bookmark
  step Model(Nurse, :find)
  step Policy::Pundit(NursePolicy, :bookmark?)
  step :process
end

require_dependency 'employee/operation/downvote'

class Nurse::Downvote < ::Employee::Downvote
  step Model(Nurse, :find)
  step Policy::Pundit(NursePolicy, :show?)
  step :process
end

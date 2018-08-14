require_dependency 'employee/operation/upvote'

class Nurse::Upvote < ::Employee::Upvote
  step Model(Nurse, :find)
  step Policy::Pundit(NursePolicy, :show?)
  step :process
end

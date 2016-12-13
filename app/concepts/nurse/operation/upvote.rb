require_dependency 'employee/operation/upvote'

class Nurse::Upvote < ::Employee::Upvote
  model  Nurse, :find
  policy NursePolicy, :show?
end

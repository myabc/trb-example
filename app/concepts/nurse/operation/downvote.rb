require_dependency 'employee/operation/downvote'

class Nurse::Downvote < ::Employee::Downvote
  model  Nurse, :find
  policy NursePolicy, :show?
end

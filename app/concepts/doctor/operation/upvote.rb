require_dependency 'employee/operation/upvote'

class Doctor::Upvote < ::Employee::Upvote
  model  Doctor, :find
  policy DoctorPolicy, :show?
end

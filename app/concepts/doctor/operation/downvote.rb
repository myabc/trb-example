require_dependency 'employee/operation/downvote'

class Doctor::Downvote < ::Employee::Downvote
  model  Doctor, :find
  policy DoctorPolicy, :show?
end

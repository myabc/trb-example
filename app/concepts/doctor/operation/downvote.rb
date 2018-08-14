require_dependency 'employee/operation/downvote'

class Doctor::Downvote < ::Employee::Downvote
  step Model(Doctor, :find)
  step Policy::Pundit(DoctorPolicy, :show?)
  step :process
end

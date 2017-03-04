require_dependency 'employee/operation/upvote'

class Doctor::Upvote < ::Employee::Upvote
  step Model(Doctor, :find)
  step Policy::Pundit(DoctorPolicy, :show?)
  step :process
end

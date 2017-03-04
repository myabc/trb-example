require_dependency 'employee/operation/index'

class Doctor::Index < ::Employee::Index
  representer :render, V1::DoctorsRepresenter

  def model!(options, params:, current_user:, **)
    options['model'] = DoctorPolicy::Scope.new(
      current_user, find_clinic(params).doctors
    ).resolve.includes(:author)
  end
end

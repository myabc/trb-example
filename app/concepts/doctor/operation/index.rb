require_dependency 'employee/operation/index'

class Doctor::Index < ::Employee::Index
  representer V1::DoctorsRepresenter

  def model!(params)
    DoctorPolicy::Scope.new(
      params.fetch(:current_user), find_clinic(params).doctors
    ).resolve.includes(:author)
  end
end

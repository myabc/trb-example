require_dependency 'employee/operation/index'

class Nurse::Index < ::Employee::Index
  representer V1::NursesRepresenter

  def model!(params)
    NursePolicy::Scope.new(
      params.fetch(:current_user), find_clinic(params).nurses
    ).resolve.includes(:qualifications, :author)
  end
end

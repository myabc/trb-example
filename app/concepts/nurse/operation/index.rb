require_dependency 'employee/operation/index'

class Nurse::Index < ::Employee::Index
  representer :serializer, V1::NursesRepresenter

  def model!(options, params:, current_user:, **)
    options['model'] = NursePolicy::Scope.new(
      current_user, find_clinic(params).nurses
    ).resolve.includes(:qualifications, :author)
  end
end

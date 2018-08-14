class Department::Index < Trailblazer::Operation
  step :model!

  extend Representer::DSL
  representer :serializer, V1::DepartmentsRepresenter

  def model!(options, params:, current_user:, **)
    options['model'] = DepartmentPolicy::Scope.new(
      current_user, find_hospital(params).departments
    ).resolve
                                              .order(created_at: :asc)
                                              .includes(:creator)
  end

  private

  def find_hospital(params)
    Hospital.friendly.find(params[:hospital_id])
  end
end

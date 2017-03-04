class Clinic::Index < Trailblazer::Operation
  step :model!

  extend Representer::DSL
  representer :render, V1::ClinicsRepresenter

  def model!(options, params:, current_user:, **)
    options['model'] = ClinicPolicy::Scope.new(
      current_user, find_department(params).clinics
    ).resolve.eager_load(:author)
  end

  private

  def find_department(params)
    Department.friendly.find(params[:department_id])
  end
end

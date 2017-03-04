class Clinic::Create < Trailblazer::Operation
  step :model!
  step Policy::Pundit(ClinicPolicy, :create?)
  step Contract::Build(constant: Clinic::Contract::Create)
  step Contract::Validate(key: 'clinic')
  step Contract::Persist()

  extend Representer::DSL
  representer :render, V1::ClinicRepresenter

  def model!(options, params:, current_user:, **)
    clinic         = find_department(params).clinics.new
    clinic.author  = current_user
    options['model'] = clinic
  end

  private

  def find_department(params)
    Department.friendly.find(params[:department_id])
  end
end

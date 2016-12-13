class Clinic::Create < Trailblazer::Operation
  include Policy
  policy ClinicPolicy, :create?

  include Representer
  include Representer::Deserializer::Hash
  representer V1::ClinicRepresenter

  contract Clinic::Contract::Create

  def model!(params)
    clinic         = find_department(params).clinics.new
    clinic.author  = params.fetch(:current_user)
    clinic
  end

  def process(params)
    validate(params, &:save)
  end

  def to_json(*)
    super({
      user_options: {
        current_user: @params.fetch(:current_user)
      }
    })
  end

  private

  def find_department(params)
    Department.friendly.find(params[:department_id])
  end
end

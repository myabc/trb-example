class Clinic::Update < Trailblazer::Operation
  include Model
  include Policy
  model  Clinic,       :update
  policy ClinicPolicy, :update?

  include Representer
  include Representer::Deserializer::Hash
  representer V1::ClinicRepresenter

  contract Clinic::Contract::Update

  def process(params)
    validate(params) do
      contract.save
    end
  end

  def to_json(*)
    super({
      user_options: {
        current_user: @params.fetch(:current_user)
      }
    })
  end
end

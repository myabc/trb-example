class Clinic::Show < Trailblazer::Operation
  include Model
  include Policy
  model  Clinic,       :find
  policy ClinicPolicy, :show?

  include Representer
  representer V1::ClinicRepresenter

  def process(_params); end

  def to_json(*)
    super({
      user_options: {
        current_user: @params.fetch(:current_user)
      }
    })
  end
end

class Clinic::Delete < Trailblazer::Operation
  include Model
  include Policy
  model  Clinic,       :find
  policy ClinicPolicy, :destroy?

  def process(_params)
    model.destroy!
  end
end

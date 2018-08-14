class Clinic::Delete < Trailblazer::Operation
  step Model(Clinic, :find)
  step Policy::Pundit(ClinicPolicy, :destroy?)
  step :process

  def process(_options, model:, **)
    model.destroy!
  end
end

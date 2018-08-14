class Employee::Create < Trailblazer::Operation
  extend Contract::DSL
  extend Representer::DSL

  def assign_author(_options, model:, current_user:, **)
    model.author = current_user
  end

  private

  def find_clinic(params)
    Clinic.find(params.fetch(:clinic_id))
  end
end

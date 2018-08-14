class Employee::Index < Trailblazer::Operation
  extend Representer::DSL

  step :model!

  private

  def find_clinic(params)
    Clinic.find(params.fetch(:clinic_id))
  end
end

class Employee::Create < Trailblazer::Operation
  include Policy
  include Representer
  include Representer::Deserializer::Hash

  def process(params)
    validate(params) do
      model.author = params.fetch(:current_user)

      contract.save

      process_employee
    end
  end

  def process_employee; end

  def self.find_clinic(params)
    Clinic.find(params.fetch(:clinic_id))
  end
end

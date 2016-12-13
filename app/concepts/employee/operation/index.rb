class Employee::Index < Trailblazer::Operation
  include Representer

  def process(_params); end

  private

  def find_clinic(params)
    Clinic.find(params.fetch(:clinic_id))
  end
end

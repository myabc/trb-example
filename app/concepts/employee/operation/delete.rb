class Employee::Delete < Trailblazer::Operation
  include Model
  include Policy

  def process(_params)
    model.destroy
  end
end

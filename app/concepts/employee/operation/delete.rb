class Employee::Delete < Trailblazer::Operation
  def process(_options, model:, **)
    model.destroy
  end
end

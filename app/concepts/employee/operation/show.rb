class Employee::Show < Trailblazer::Operation
  include Model
  include Policy
  include Representer

  def process(_params); end
end

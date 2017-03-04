class Department::Delete < Trailblazer::Operation
  step :model!
  step Policy::Pundit(DepartmentPolicy, :destroy?)
  step :process

  def model!(options, params:, **)
    options['model'] = Department.friendly.find(params[:id])
  end

  def process(_options, model:, **)
    model.destroy!
  end
end

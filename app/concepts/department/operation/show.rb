class Department::Show < Trailblazer::Operation
  step :model!
  step Policy::Pundit(DepartmentPolicy, :show?)

  extend Representer::DSL
  representer :render, V1::DepartmentRepresenter

  def model!(options, params:, **)
    options['model'] = Department.friendly.find(params[:id])
  end
end

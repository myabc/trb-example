class Ward::Index < Trailblazer::Operation
  step :model!

  extend Representer::DSL
  representer :render, V1::WardsRepresenter

  def model!(options, params:, current_user:, **)
    options['model'] = WardPolicy::Scope.new(
      current_user, find_department(params).wards
    ).resolve.eager_load(:creator)
  end

  private

  def find_department(params)
    Department.find(params[:department_id])
  end
end

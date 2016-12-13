class Department::Show < Trailblazer::Operation
  include Policy
  policy DepartmentPolicy, :show?

  include Representer
  representer V1::DepartmentRepresenter

  def model!(params)
    Department.friendly.find(params[:id])
  end

  def process(_params); end

  def to_json(*)
    include_params      = @params.fetch(:include, '').split(',').map(&:strip)
    permitted_includes  = %w(nurses doctors) & include_params

    super({
      user_options: {
        current_user: @params.fetch(:current_user),
        includes:     permitted_includes
      }
    })
  end
end

class Ward::Index < Trailblazer::Operation
  include Representer
  representer V1::WardsRepresenter

  def model!(params)
    WardPolicy::Scope.new(
      params.fetch(:current_user), find_department(params).wards
    ).resolve.eager_load(:creator)
  end

  def process(_params); end

  def to_json(*)
    super({
      user_options: {
        current_user: @params.fetch(:current_user)
      }
    })
  end

  private

  def find_department(params)
    Department.find(params[:department_id])
  end
end

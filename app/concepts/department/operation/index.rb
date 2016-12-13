class Department::Index < Trailblazer::Operation
  include Representer
  representer V1::DepartmentsRepresenter

  def model!(params)
    DepartmentPolicy::Scope.new(
      params.fetch(:current_user), find_hospital(params).departments
    ).resolve
                           .order(created_at: :asc)
                           .includes(:creator)
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

  def find_hospital(params)
    Hospital.friendly.find(params[:hospital_id])
  end
end

class Clinic::Index < Trailblazer::Operation
  include Representer
  representer V1::ClinicsRepresenter

  def model!(params)
    ClinicPolicy::Scope.new(
      params.fetch(:current_user), find_department(params).clinics
    ).resolve.eager_load(:author)
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
    Department.friendly.find(params[:department_id])
  end
end

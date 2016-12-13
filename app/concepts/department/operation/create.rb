class Department::Create < Trailblazer::Operation
  include Resolver

  include Model
  include Policy
  model  Department,       :create
  policy DepartmentPolicy, :create?

  include Representer
  include Representer::Deserializer::Hash

  builds ->(_model, policy, _params) do
    return self::Privileged if policy.user_is_privileged?
    self::Default
  end

  def self.model!(params)
    department          = find_hospital(params).departments.new
    department.creator  = params.fetch(:current_user)
    department
  end

  class Default < self
    representer V1::DepartmentRepresenter

    contract Department::Contract::Create
  end

  class Privileged < Default
    representer V1::DepartmentRepresenter do
      include V1::DepartmentRepresenter::CreatePrivileged
    end

    contract Department::Contract::Create do
      include Department::Contract::CreatePrivileged
    end
  end

  def process(params)
    validate(params) do |contract|
      contract.save

      model.reload
    end
  end

  def to_json(*)
    super({
      user_options: {
        current_user: @params.fetch(:current_user)
      }
    })
  end

  def self.find_hospital(params)
    Hospital.friendly.find(params[:hospital_id])
  end
end

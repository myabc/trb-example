class Department::Update < Trailblazer::Operation
  include Resolver

  include Model
  include Policy
  model  Department,       :update
  policy DepartmentPolicy, :update?

  include Representer
  include Representer::Deserializer::Hash

  builds ->(_model, policy, _params) do
    return self::Privileged if policy.user_is_privileged?
    self::Default
  end

  def self.model!(params)
    Department.friendly.find(params[:id])
  end

  class Default < self
    representer V1::DepartmentRepresenter

    contract Department::Contract::Update
  end

  class Privileged < Default
    representer V1::DepartmentRepresenter do
      include V1::DepartmentRepresenter::UpdatePrivileged
    end

    contract Department::Contract::Update do
      include Department::Contract::UpdatePrivileged
    end
  end

  def process(params)
    validate(params) do
      contract.save
    end
  end

  def to_json(*)
    super({
      user_options: {
        current_user: @params.fetch(:current_user)
      }
    })
  end
end

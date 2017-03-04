class Department::Update < Trailblazer::Operation
  step :model!
  step Policy::Pundit(DepartmentPolicy, :update?)
  # step Nested(:build!)
  step Contract::Build(constant: Department::Contract::Create)
  step Contract::Validate(key: 'department')
  step Contract::Persist()

  def build!(options, **)
    return self.class::Privileged if options['policy.default'].user_is_privileged?
    self.class::Default
  end

  def model!(options, params:, **)
    options['model'] = Department.friendly.find(params[:id])
  end

  class Default < Trailblazer::Operation
    extend Contract::DSL
    extend Representer::DSL

    representer :render, V1::DepartmentRepresenter

    contract Department::Contract::Update
  end

  class Privileged < Default
    representer :render, V1::DepartmentRepresenter do
      include V1::DepartmentRepresenter::UpdatePrivileged
    end

    contract Department::Contract::Update do
      include Department::Contract::UpdatePrivileged
    end
  end
end

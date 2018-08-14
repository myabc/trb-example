class Department::Create < Trailblazer::Operation
  step :model!
  step Policy::Pundit(DepartmentPolicy, :create?)
  # step Nested(:build!)
  step Contract::Build(constant: Department::Contract::Create)
  step Contract::Validate(key: 'department')
  step Contract::Persist()

  def build!(options, **)
    return self.class::Privileged if options['policy.default'].user_is_privileged?
    self.class::Default
  end

  def model!(options, params:, current_user:, **)
    department          = find_hospital(params).departments.new
    department.creator  = current_user
    options['model']    = department
  end

  class Default < Trailblazer::Operation
    extend Contract::DSL
    extend Representer::DSL

    representer :serializer, V1::DepartmentRepresenter

    contract Department::Contract::Create
  end

  class Privileged < Default
    representer :serializer, V1::DepartmentRepresenter do
      include V1::DepartmentRepresenter::CreatePrivileged
    end

    contract Department::Contract::Create do
      include Department::Contract::CreatePrivileged
    end
  end

  private

  def find_hospital(params)
    Hospital.friendly.find(params[:hospital_id])
  end
end

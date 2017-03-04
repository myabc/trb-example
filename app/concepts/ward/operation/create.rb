class Ward::Create < Trailblazer::Operation
  step :model!
  step Policy::Pundit(WardPolicy, :create?)
  step Contract::Build(constant: Ward::Contract::Create)
  step Contract::Validate(key: 'ward')
  step Contract::Persist()

  extend Representer::DSL
  representer :render, V1::WardRepresenter

  def model!(options, params:, current_user:, **)
    ward = find_department(params).wards.new
    ward.creator = current_user
    options['model'] = ward
  end

  private

  def find_department(params)
    Department.find(params[:department_id])
  end
end

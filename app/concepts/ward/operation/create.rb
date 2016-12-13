class Ward::Create < Trailblazer::Operation
  include Policy
  policy WardPolicy, :create?

  include Representer
  include Representer::Deserializer::Hash
  representer V1::WardRepresenter

  contract Ward::Contract::Create

  alias ward model

  def model!(params)
    ward = find_department(params).wards.new
    ward.creator = params.fetch(:current_user)
    ward
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

  private

  def find_department(params)
    Department.find(params[:department_id])
  end
end

class Commenting::Comment::Create < Trailblazer::Operation
  include Policy
  policy Commenting::CommentPolicy, :create?

  include Representer
  include Representer::Deserializer::Hash
  representer V1::CommentRepresenter

  contract do
    feature Reform::Form::Coercion
    feature Reform::Form::Dry

    property :message

    validation :default do
      configure do
        config.messages = :i18n
      end

      required(:message).filled(:str?, min_size?: 2)
    end
  end

  def model!(params)
    thread = find_employee(params).threads.first_or_create
    thread.comments.new
  end

  def process(params)
    validate(params) do |contract|
      comment         = contract.model
      comment.author  = params.fetch(:current_user)
      contract.save

      notify_author if contract.persisted?
    end
  end

  def to_json(*)
    super(user_options: { include_replies: true })
  end

  private

  def notify_author; end

  def find_employee(params)
    if params[:doctor_id]
      Doctor.find(params[:doctor_id])
    elsif params[:nurse_id]
      Nurse.find(params[:nurse_id])
    else
      raise ArgumentError
    end
  end
end

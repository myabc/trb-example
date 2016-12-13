class Commenting::Comment::CreateReply < Trailblazer::Operation
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

      required(:message).filled(:str?)
    end
  end

  def model!(params)
    reply_to_comment = Commenting::Comment.find(params.fetch(:comment_id))
    reply_to_comment.replies.new
  end

  def process(params)
    validate(params) do |contract|
      comment         = contract.model
      comment.thread  = comment.reply_to.thread
      comment.author  = params.fetch(:current_user)
      contract.save

      notify_author if contract.persisted?
    end
  end

  private

  def notify_author; end
end

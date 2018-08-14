require 'reform/form/coercion'

class Commenting::Comment::CreateReply < Trailblazer::Operation
  step :model!
  step Policy::Pundit(Commenting::CommentPolicy, :create?)
  step Contract::Build()
  step :assign_thread
  step :assign_author
  step Contract::Validate(key: 'comment')
  step Contract::Persist()

  extend Representer::DSL
  representer :serializer, V1::CommentRepresenter

  extend Contract::DSL

  contract do
    feature Reform::Form::Coercion

    property :message

    validation :default do
      configure do
        config.messages = :i18n
      end

      required(:message).filled(:str?)
    end
  end

  def model!(options, params:, **)
    reply_to_comment = Commenting::Comment.find(params.fetch(:comment_id))
    options['model'] = reply_to_comment.replies.new
  end

  def assign_thread(_options, model:, **)
    model.thread = model.reply_to.thread
  end

  def assign_author(_options, model:, current_user:, **)
    model.author = current_user
  end

  private

  def notify_author; end
end

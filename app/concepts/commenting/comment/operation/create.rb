require 'reform/form/coercion'

class Commenting::Comment::Create < Trailblazer::Operation
  step :model!
  step Policy::Pundit(Commenting::CommentPolicy, :create?)
  step Contract::Build()
  step :assign_author
  step Contract::Validate(key: 'comment')
  step Contract::Persist()

  extend Representer::DSL
  representer :render, V1::CommentRepresenter

  extend Contract::DSL

  contract do
    feature Reform::Form::Coercion

    property :message

    validation :default do
      configure do
        config.messages = :i18n
      end

      required(:message).filled(:str?, min_size?: 2)
    end
  end

  def model!(options, params:, **)
    thread            = find_employee(params).threads.first_or_create
    options['model']  = thread.comments.new
  end

  def assign_author(_options, model:, current_user:, **)
    model.author = current_user
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

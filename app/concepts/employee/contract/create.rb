module Employee::Contract
  class Create < Reform::Form
    feature Reform::Form::Coercion
    feature Reform::Form::Dry

    property :status, default: :former

    validation :default do
      configure do
        config.messages = :i18n
      end

      required(:status).filled(:str?, included_in?: %w(former current))
    end
  end

  module CreatePrivileged
    include Reform::Form::Module
  end
end

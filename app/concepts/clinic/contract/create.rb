require 'reform/form/coercion'
require 'reform/form/dry'

module Clinic::Contract
  class Create < Reform::Form
    feature Reform::Form::Coercion
    feature Reform::Form::Dry

    property :title

    validation :default do
      configure do
        config.messages = :i18n
      end

      required(:title).filled(:str?, max_size?: 50)
    end

    def title=(value)
      super(value.strip.presence)
    end
  end
end

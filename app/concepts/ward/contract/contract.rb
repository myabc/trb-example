require 'reform/form/coercion'
require 'reform/form/dry'

module Ward::Contract
  class Create < Reform::Form
    feature Reform::Form::Coercion
    feature Reform::Form::Dry

    property :name
    property :description
    property :category
    property :url, virtual: true
    property :emergency, type: Types::Form::Bool

    validation do
      configure do
        config.messages = :i18n

        def url?(value)
          uri = Addressable::URI.parse(value)
          %w(http https).include?(uri.scheme)
        rescue Addressable::URI::InvalidURIError
          false
        end
      end

      required(:category).filled(:str?, included_in?: Ward::CATEGORIES)
      required(:name).filled(:str?)
      optional(:description).filled(:str?, max_size?: 500)
      required(:url).filled(:str?, :url?)
      optional(:emergency).filled(:bool?)
    end

    def description=(value)
      super(value.strip.presence)
    end
  end
end

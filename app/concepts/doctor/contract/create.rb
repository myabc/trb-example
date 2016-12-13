require_dependency 'employee/contract/create'

module Doctor::Contract
  class Create < Employee::Contract::Create
    property :biography
    property :biography_html
    property :notes
    property :notes_html

    validation :default do
      configure do
        config.messages = :i18n
      end

      required(:biography_html).filled(:str?)
      required(:notes_html).filled(:str?)
    end
  end
end

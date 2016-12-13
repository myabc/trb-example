require_dependency 'employee/contract/create'

module Nurse::Contract
  class Create < Employee::Contract::Create
    property :notes
    property :notes_html

    validation :default do
      configure do
        config.messages = :i18n
      end

      required(:notes_html).filled(:str?)
      required(:qualifications).filled(min_size?: 2)
    end

    collection :qualifications, populator: :qualification! do
      property :name
      property :position

      validation :default do
        configure do
          config.messages = :i18n
        end

        required(:name).filled(:str?)
      end
    end

    private

    def qualification!(collection:, fragment:, **)
      if fragment['id'].present?
        qualification = collection.detect { |item|
          item.id == fragment['id']
        }
      end

      if fragment['_destroy'] == true
        collection.delete(qualification) if qualification
        skip!
      else
        qualification || collection.append(model.qualifications.new)
      end
    end
  end
end

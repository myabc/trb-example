require 'reform/form/coercion'
require 'reform/form/dry'

module Department::Contract
  class Create < Reform::Form
    feature Reform::Form::Coercion

    property :title
    property :director_name
    property :org_code

    collection :clinics, populator: :clinic!, form: Clinic::Contract::Create

    validation do
      configure do
        config.messages = :i18n
      end

      required(:title).filled(:str?, max_size?: 65, format?: /\A[[:alpha:]]/)
    end

    def title=(value)
      super(value.strip.presence)
    end

    private

    def clinic!(collection:, **)
      collection.append(model.clinics.new(author: model.creator))
    end
  end

  module CreatePrivileged
    include Reform::Form::Module

    property :hospital_id
    property :published
    property :department_page_url
    property :number_of_patients
  end
end

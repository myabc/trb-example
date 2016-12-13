module Nurse::Contract
  class Update < Create
    collection :qualifications, inherit: true do
      property :id,       writeable: false
      property :_destroy, virtual: true

      def marked_for_destruction?
        !!_destroy
      end
    end

    def valid_qualifications
      qualifications.reject(&:marked_for_destruction?)
    end
  end
end

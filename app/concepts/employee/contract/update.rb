module Employee::Contract
  module UpdatePrivileged
    include Reform::Form::Module

    property :author_id
    property :clinic_id
    property :status
  end
end

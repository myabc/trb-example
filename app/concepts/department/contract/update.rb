module Department::Contract
  class Update < Create
  end

  module UpdatePrivileged
    include Reform::Form::Module
    include CreatePrivileged
  end
end

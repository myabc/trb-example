class V1::BaseRepresenter < Roar::Decorator
  include Roar::JSON

  defaults render_nil: true
end

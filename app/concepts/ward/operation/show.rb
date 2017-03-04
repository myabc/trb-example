require_dependency 'ward/operation/fetch'

class Ward::Show < Ward::Fetch
  extend Representer::DSL
  representer :render, V1::WardRepresenter
end

require_dependency 'ward/operation/fetch'

class Ward::Show < Ward::Fetch
  extend Representer::DSL
  representer :serializer, V1::WardRepresenter
end

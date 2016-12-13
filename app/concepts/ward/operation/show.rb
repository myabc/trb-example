require_dependency 'ward/operation/fetch'

class Ward::Show < Ward::Fetch
  include Representer
  representer V1::WardRepresenter

  def to_json(*)
    super({
      user_options: {
        current_user: @params.fetch(:current_user)
      }
    })
  end
end

module TokenMacros
  def generate_access_token_for(user)
    Doorkeeper::AccessToken.create!(
      application_id: test_application.id,
      resource_owner_id: user.id
    ).token
  end

  def generate_anonymous_access_token
    Doorkeeper::AccessToken.create!(application_id: test_application.id).token
  end

  def test_application
    @application ||= Doorkeeper::Application
                     .find_or_create_by!(name: 'Trailblazer Test App') { |app|
      app.redirect_uri = 'https://app.com'
    }
  end
end

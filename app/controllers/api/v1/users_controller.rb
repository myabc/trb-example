class Api::V1::UsersController < Api::V1::ApiController
  load_resource

  def show
    authorize @user, :show_profile?
    respond_with @user, represent_with: ::V1::UserRepresenter
  end
end

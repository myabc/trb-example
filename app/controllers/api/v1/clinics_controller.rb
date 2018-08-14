class Api::V1::ClinicsController < Api::V1::ApiController
  include Trailblazer::Endpoint::Controller

  def index
    endpoint Clinic::Index, args: [params, { 'current_user' => current_user }]
  end

  def show
    endpoint Clinic::Show, args: [params, { 'current_user' => current_user }]
  end

  def create
    endpoint Clinic::Create, args: [params, { 'current_user' => current_user }]
  end

  def update
    endpoint Clinic::Update, args: [params, { 'current_user' => current_user }]
  end

  def destroy
    endpoint Clinic::Delete, args: [params, { 'current_user' => current_user }]
    # head :no_content
  end
end

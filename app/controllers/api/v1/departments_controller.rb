class Api::V1::DepartmentsController < Api::V1::ApiController
  include Trailblazer::Endpoint::Controller

  def index
    endpoint Department::Index, args: [params, { 'current_user' => current_user }]
  end

  def show
    endpoint Department::Show, args: [params, { 'current_user' => current_user }]
  end

  def create
    endpoint Department::Create, args: [params, { 'current_user' => current_user }]
  end

  def update
    endpoint Department::Update, args: [params, { 'current_user' => current_user }]
  end

  def destroy
    endpoint Department::Delete, args: [params, { 'current_user' => current_user }]
    # head :no_content
  end
end

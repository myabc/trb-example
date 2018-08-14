class Api::V1::CommentsController < Api::V1::ApiController
  include Trailblazer::Endpoint::Controller

  def index
    endpoint Commenting::Comment::Index, args: [params, { 'current_user' => current_user }]
  end

  def create
    endpoint Commenting::Comment::Create, args: [params, { 'current_user' => current_user }]
  end

  def destroy
    endpoint Commenting::Comment::Delete, args: [params, { 'current_user' => current_user }]
    # head :no_content
  end

  def report
    endpoint Commenting::Comment::Report, args: [params, { 'current_user' => current_user }]
    # head :no_content
  end
end

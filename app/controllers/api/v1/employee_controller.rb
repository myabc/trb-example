class Api::V1::EmployeeController < Api::V1::ApiController
  include Trailblazer::Endpoint::Controller

  class_attribute :operation_namespace

  def index
    endpoint operation_namespace::Index, args: [params, { 'current_user' => current_user }]
  end

  def create
    endpoint operation_namespace::Create, args: [params, { 'current_user' => current_user }]
  end

  def show
    endpoint operation_namespace::Show, args: [params, { 'current_user' => current_user }]
  end

  def update
    endpoint operation_namespace::Update, args: [params, { 'current_user' => current_user }]
  end

  def destroy
    endpoint operation_namespace::Delete, args: [params, { 'current_user' => current_user }]
    # head :no_content
  end

  def bookmark
    endpoint operation_namespace::Bookmark, args: [params, { 'current_user' => current_user }]
    # head :no_content
  end

  def unbookmark
    endpoint operation_namespace::Unbookmark, args: [params, { 'current_user' => current_user }]
    # head :no_content
  end

  def upvote
    endpoint operation_namespace::Upvote, args: [params, { 'current_user' => current_user }]
    # head :no_content
  end

  def downvote
    endpoint operation_namespace::Downvote, args: [params, { 'current_user' => current_user }]
    # head :no_content
  end
end

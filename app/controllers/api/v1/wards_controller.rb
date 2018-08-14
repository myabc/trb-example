class Api::V1::WardsController < Api::V1::ApiController
  include Trailblazer::Endpoint::Controller

  def index
    endpoint Ward::Index, args: [params, { 'current_user' => current_user }]
  end

  def show
    endpoint Ward::Show, args: [params, { 'current_user' => current_user }]
  end

  def create
    endpoint Ward::Create, args: [params, { 'current_user' => current_user }]
  end

  def destroy
    endpoint Ward::Delete, args: [params, { 'current_user' => current_user }]
    # head :no_content
  end

  def bookmark
    endpoint Ward::Bookmark, args: [params, { 'current_user' => current_user }]
    # head :no_content
  end

  def unbookmark
    endpoint Ward::Unbookmark, args: [params, { 'current_user' => current_user }]
    # head :no_content
  end

  def upvote
    endpoint Ward::Upvote, args: [params, { 'current_user' => current_user }]
    # head :no_content
  end
end

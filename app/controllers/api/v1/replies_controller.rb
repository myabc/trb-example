class Api::V1::RepliesController < Api::V1::ApiController
  include Trailblazer::Endpoint::Controller

  def create
    endpoint Commenting::Comment::CreateReply, args: [params, { 'current_user' => current_user }]
  end
end

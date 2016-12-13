class Api::V1::RepliesController < Api::V1::ApiController
  self.responder = ::ApiResponder

  def create
    respond Commenting::Comment::CreateReply
  end

  private

  def params!(params)
    params.merge(current_user: current_user)
  end
end

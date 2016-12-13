class Api::V1::CommentsController < Api::V1::ApiController
  self.responder = ::ApiResponder

  def index
    respond Commenting::Comment::Index
  end

  def create
    respond Commenting::Comment::Create
  end

  def destroy
    run Commenting::Comment::Delete
    head :no_content
  end

  def report
    run Commenting::Comment::Report
    head :no_content
  end

  private

  def params!(params)
    params.merge(current_user: current_user)
  end
end

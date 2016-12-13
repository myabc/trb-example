class Api::V1::WardsController < Api::V1::ApiController
  self.responder = ::ApiResponder

  def index
    respond Ward::Index
  end

  def show
    respond Ward::Show
  end

  def create
    respond Ward::Create
  end

  def destroy
    run Ward::Delete
    head :no_content
  end

  def bookmark
    run Ward::Bookmark
    head :no_content
  end

  def unbookmark
    run Ward::Unbookmark
    head :no_content
  end

  def upvote
    run Ward::Upvote
    head :no_content
  end

  private

  def params!(params)
    params.merge(current_user: current_user)
  end
end

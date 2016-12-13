class Api::V1::EmployeeController < Api::V1::ApiController
  self.responder = ::ApiResponder

  class_attribute :operation_namespace

  def index
    respond operation_namespace::Index
  end

  def create
    respond operation_namespace::Create
  end

  def show
    respond operation_namespace::Show
  end

  def update
    respond operation_namespace::Update
  end

  def destroy
    run operation_namespace::Delete
    head :no_content
  end

  def bookmark
    run operation_namespace::Bookmark
    head :no_content
  end

  def unbookmark
    run operation_namespace::Unbookmark
    head :no_content
  end

  def upvote
    run operation_namespace::Upvote
    head :no_content
  end

  def downvote
    run operation_namespace::Downvote
    head :no_content
  end

  private

  def params!(params)
    params.merge(current_user: current_user)
  end
end

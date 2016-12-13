class Api::V1::DepartmentsController < Api::V1::ApiController
  self.responder = ::ApiResponder

  def index
    respond Department::Index
  end

  def show
    respond Department::Show
  end

  def create
    respond Department::Create
  end

  def update
    respond Department::Update
  end

  def destroy
    run Department::Delete
    head :no_content
  end

  private

  def params!(params)
    params.merge(current_user: current_user)
  end
end

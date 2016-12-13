class Api::V1::ClinicsController < Api::V1::ApiController
  self.responder = ::ApiResponder

  def index
    respond Clinic::Index
  end

  def show
    respond Clinic::Show
  end

  def create
    respond Clinic::Create
  end

  def update
    respond Clinic::Update
  end

  def destroy
    run Clinic::Delete
    head :no_content
  end

  private

  def params!(params)
    params.merge(current_user: current_user)
  end
end

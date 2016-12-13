class Api::V1::HospitalsController < Api::V1::ApiController
  def show
    @hospital = Hospital.friendly.find(params[:id])
    authorize @hospital
    respond_with @hospital, represent_with: ::V1::HospitalRepresenter
  end

  def index
    @hospitals = policy_scope(Hospital.all)
    respond_with @hospitals, represent_with: ::V1::HospitalsRepresenter
  end
end

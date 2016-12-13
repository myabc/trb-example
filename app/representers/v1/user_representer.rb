class V1::UserRepresenter < V1::BaseRepresenter
  self.representation_wrap = :user

  property :id
  property :email
  property :first_name
  property :last_name
  property :nickname

  property :weight

  property :hospital_id
  property :admin

  property :created_at
  property :updated_at

  property :locale
  property :created_employees, exec_context: :decorator

  private

  def created_employees
    doctor_count  = Doctor.where(author: represented).count
    nurse_count   = Nurse.where(author: represented).count
    doctor_count + nurse_count
  end
end

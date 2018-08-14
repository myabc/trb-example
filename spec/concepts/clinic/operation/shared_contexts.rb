RSpec.shared_context 'with an existing clinic' do
  let(:patient_author) { create(:patient) }
  let(:department) {
    create(:department, title: 'Urology')
  }

  let(:clinic_params) {
    {
      clinic:         { title: 'Kidney Stones clinic' },
      department_id:  department.id
    }.with_indifferent_access
  }

  let!(:clinic) {
    Clinic::Create.call(clinic_params, 'current_user' => patient_author)['model']
  }
end

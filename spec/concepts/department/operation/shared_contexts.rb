RSpec.shared_context 'with an existing department' do
  let(:patient_creator) { create(:patient) }
  let(:hospital) { create(:hospital) }

  let(:department_params) {
    {
      department: {
        title:    'Advanced Aeronautical Engineering'
      },
      hospital_id:  hospital.id
    }.with_indifferent_access
  }

  let!(:department) {
    Department::Create.call(department_params, 'current_user' => patient_creator)['model']
  }
end

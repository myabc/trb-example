RSpec.shared_context 'with an existing ward' do
  let(:admin)       { create(:admin) }
  let(:patient)     { create(:patient) }
  let(:department)  { create(:department, title: 'Strafrecht') }

  let(:ward_params) {
    {
      ward:    {
        name:     'Antenatal Ward',
        category: 'non_intensive',
        url:      'http://guysandstthomas.nhs.uk/our-services/wards/ward-list.aspx',
        description: 'Care during your pregnancy.'
      },
      department_id:  department.id,
      current_user:   patient
    }.with_indifferent_access
  }

  let!(:ward) {
    Ward::Create.call(ward_params).model
  }
end

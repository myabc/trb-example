RSpec.shared_context 'with an existing nurse' do
  let(:admin) { create(:admin) }
  let(:patient_author) { create(:patient) }
  let(:department) { create(:department, title: 'Pizza Making 101') }
  let(:clinic) {
    create(:clinic, department:  department,
                    title:   'Pizza margherita',
                    author:  patient_author)
  }

  let!(:nurse) { Nurse::Create.call(nurse_params, 'current_user' => patient_author)['model'] }
end

RSpec.shared_context 'with an existing former nurse' do
  include_context 'with an existing nurse'

  let(:nurse_params) {
    {
      nurse: {
        notes:      'Without patient skills, _no chance!_',
        notes_html: '<p>Without patient skills, <em>no chance!</em></p>',
        qualifications: [
          {
            name:      'Advanced Highers'
          },
          {
            name:      'A Levels'
          },
          {
            name:      'Pearson BTEC Level 3'
          }
        ]
      },
      clinic_id:   clinic.id
    }.with_indifferent_access
  }
end

RSpec.shared_context 'with an existing current nurse' do
  include_context 'with an existing nurse'

  let(:nurse_params) {
    {
      nurse: {
        notes:      'Without patient skills, _no chance!_',
        notes_html: '<p>Without patient skills, <em>no chance!</em></p>',
        current:        true,
        qualifications: [
          {
            name:      'Advanced Highers'
          },
          {
            name:      'A Levels'
          },
          {
            name:      'Pearson BTEC Level 3'
          }
        ]
      },
      clinic_id:   clinic.id
    }.with_indifferent_access
  }
end

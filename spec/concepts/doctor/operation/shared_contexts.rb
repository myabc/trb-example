RSpec.shared_context 'with an existing doctor' do
  let(:admin)           { create(:admin) }
  let(:patient_author)  { create(:patient) }
  let(:department)      { create(:department, title: 'Pizza Making 101') }
  let(:clinic) {
    create(:clinic, department:  department,
                    title:   'Pizza margherita',
                    author:  patient_author)
  }

  let!(:doctor) { Doctor::Create.call(doctor_params).model }
end

RSpec.shared_context 'with an existing former doctor' do
  include_context 'with an existing doctor'

  let(:doctor_params) {
    {
      doctor: {
        biography:      'Pizza making begins with good flour.',
        biography_html: '<p>Pizza making begins with good flour.</p>',
        notes:          'A good GP.',
        notes_html:     '<p>A good GP.</p>'
      },
      clinic_id:    clinic.id,
      current_user: patient_author
    }.with_indifferent_access
  }
end

RSpec.shared_context 'with an existing current doctor' do
  include_context 'with an existing doctor'

  let(:doctor_params) {
    {
      doctor: {
        biography:      'Pizza making begins with good flour.',
        biography_html: '<p>Pizza making begins with good flour.</p>',
        notes:          'A good GP.',
        notes_html:     '<p>A good GP.</p>',
        status:         'current'
      },
      clinic_id:    clinic.id,
      current_user: patient_author
    }.with_indifferent_access
  }
end

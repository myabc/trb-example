require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Clinic Doctors', type: :api do
  let(:user) { create(:patient) }
  let(:clinic_author) { create(:patient) }
  let(:authorization_header) { "Bearer #{generate_access_token_for(user)}" }
  let(:hospital) {
    create(:hospital,
           name:    'St Bartholomew\'s Hospital',
           acronym: 'BL',
           url:     'http://bartshealth.nhs.uk/',
           street:  'W Smithfield',
           street_number:  '',
           postal_code:    'EC1A 7BE')
  }
  let(:department) {
    create(:department,
           title:      'Endocrinology',
           creator:    create(:admin),
           hospital: hospital)
  }
  let(:clinic) {
    create(:clinic,
           title:  'GUM Clinic',
           department: department,
           author: clinic_author)
  }
  let(:clinic_id) { clinic.id }

  header 'Host',          'api.gotrailblazer.test'
  header 'Content-Type',  'application/json'
  header 'Authorization', :authorization_header

  get '/v1/clinics/:clinic_id/doctors' do
    it_behaves_like 'a collection resource', 'doctors' do
      let(:collection) {
        create_list(:doctor, 3, author: user, clinic: clinic)
      }
    end
  end

  post '/v1/clinics/:clinic_id/doctors' do
    let(:raw_post) { params.to_json }

    with_options scope: :doctor, required: true do
      parameter :biography_html,  'Biography HTML'
      parameter :notes_html,      'Notes HTML'
    end

    with_options scope: :doctor do
      parameter :biography, 'Biography Markdown'
      parameter :notes,     'Notes Markdown'
      parameter :published, 'Published'
      parameter :clinic_id, 'Clinic ID'
    end

    example 'Create a doctor' do
      do_request(doctor: {
                   biography_html:  '<strong>Great</strong> doc',
                   notes_html:      'Helps things <strong>heal</strong>'
                 })

      expect(response_status).to be 201
      expect(response_body).to have_json_path 'doctor'
    end
  end
end

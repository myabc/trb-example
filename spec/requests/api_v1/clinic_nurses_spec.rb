require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Clinic Nurses', type: :api do
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

  get '/v1/clinics/:clinic_id/nurses' do
    it_behaves_like 'a collection resource', 'nurses' do
      let(:collection) { create_list(:nurse, 3, clinic: clinic) }
    end
  end

  post '/v1/clinics/:clinic_id/nurses' do
    with_options scope: :nurse, required: true do
      parameter :notes_html, 'Notes HTML'
    end

    with_options scope: :nurse do
      parameter :nurse,           'Nurse Markdown'
      parameter :notes,           'Notes Markdown'
      parameter :published,       'Published'
      parameter :clinic_id,       'Clinic ID'
      parameter :qualifications,  'Qualification Options'
    end

    with_options scope: [:nurse, :qualifications] do
      parameter :content,         'Qualification Content Markdown'
      parameter :content_html,    'Qualification Content HTML'
    end

    let(:notes) { 'the notes is simple: **care**' }
    let(:raw_post) { params.to_json }

    example 'Create a nurse' do
      do_request(nurse: {
                   notes_html: 'the notes is simple: <strong>care</strong>',
                   qualifications: [
                     {
                       name: 'Qualification 1'
                     },
                     {
                       name: 'Qualification 2'
                     }
                   ]
                 })

      expect(response_status).to be 201
      expect(response_body).to have_json_path 'nurse'
    end
  end
end

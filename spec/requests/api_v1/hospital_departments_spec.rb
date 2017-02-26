require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Hospital Departments', type: :api do
  let(:user)                  { create(:patient) }
  let(:authorization_header)  { "Bearer #{generate_access_token_for(user)}" }
  let(:hospital) {
    create(:hospital,
           name:    'St Bartholomew\'s Hospital',
           acronym: 'BL',
           url:     'http://bartshealth.nhs.uk/',
           street:  'W Smithfield',
           street_number:  '',
           postal_code:    'EC1A 7BE')
  }

  header 'Host',          'api.gotrailblazer.test'
  header 'Content-Type',  'application/json'
  header 'Authorization', :authorization_header

  get '/v1/hospitals/:hospital_slug/departments' do
    let(:departments) {
      create_list(:department, 2,
                  creator:    create(:admin),
                  hospital: hospital)
      create_list(:department, 2,
                  creator:    create(:admin),
                  hospital: hospital)
    }

    context 'with slug' do
      let(:hospital_slug) { hospital.friendly_id }

      context 'as a patient', document: :patient do
        it_behaves_like 'a collection resource', 'departments' do
          let(:collection) { departments }
          let(:collection_size) { 4 }
        end

        example 'Get a list' do
          departments
          clinic = create(:clinic, department: departments.last)
          create(:doctor, clinic: clinic, status: :former)
          create(:nurse,  clinic: clinic)

          do_request
        end
      end

      context 'as an admin', document: :admin do
        let(:user) { create(:admin) }

        it_behaves_like 'a collection resource', 'departments' do
          let(:collection) { departments }
          let(:collection_size) { 4 }
        end

        example 'Get a list' do
          departments
          clinic = create(:clinic, department: departments.last)
          create(:doctor, clinic: clinic, status: :former)
          create(:nurse,  clinic: clinic)

          do_request
        end
      end

      context 'as an admin', document: :admin do
        let(:user) { create(:admin) }

        it_behaves_like 'a collection resource', 'departments' do
          let(:collection)      { departments }
          let(:collection_size) { 4 }
        end

        example 'Get a list' do
          departments
          clinic = create(:clinic, department: departments.last)
          create(:doctor, clinic: clinic, status: :former)
          create(:nurse,  clinic: clinic)

          do_request
        end
      end
    end
  end

  post '/v1/hospitals/:hospital_slug/departments' do
    with_options scope: :department, required: true do
      parameter :title, 'Title'
    end

    with_options scope: :department do
      parameter :clinics,         'Clinics'
      parameter :director_name,   'Director name'
      parameter :contact_phones,  'Contact phones'
      parameter :clinics,         'Clinics'
      parameter :org_code,        'Organisational code'
      parameter :hospital_id,     'Hospital ID'
      parameter :published,       'Published'
      parameter :department_page_url,   'Department Page URL'
      parameter :number_of_patients,    'Number of Patients'
    end

    with_options scope: [:department, :clinics] do
      parameter :title, 'Clinic title'
    end

    let(:raw_post) { params.to_json }

    context 'with slug' do
      let(:hospital_slug) { hospital.friendly_id }

      context 'as a patient', document: :patient do
        example 'Create a published department, ignoring unpermitted properties' do
          do_request(department: {
                       title:     'Immunology',
                       published: false
                     })

          expect(response_status).to be 201
          expect(response_body).to have_json_path 'department'
        end

        example 'Create a published department with clinics' do
          do_request(department: {
                       title:     'Immunology',
                       clinics: [
                         { title: 'Immunology Clinic 1' },
                         { title: 'Immunology Clinic 2' },
                         { title: 'Immunology Clinic 3' }
                       ]
                     })

          expect(response_status).to be 201
          expect(response_body).to have_json_path 'department'

          expect(response_body).to have_json_path 'department/clinics'
          expect(response_body).to have_json_size(3).at_path('department/clinics')
          expect(parse_json(response_body, 'department/clinics/0/title'))
            .to eq 'Immunology Clinic 1'
          expect(parse_json(response_body, 'department/clinics/0/author_id'))
            .to eq user.id
        end
      end

      context 'as an admin', document: :admin do
        let(:user) { create(:admin) }

        example 'Create an unpublished department, respecting permitted properties' do
          do_request(department: {
                       title:         'Immunology',
                       published:     false
                     })

          expect(response_status).to be 201
          expect(response_body).to have_json_path 'department'
        end
      end
    end
  end
end

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Department Clinics', type: :api do
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
  let(:department_creator)        { create(:admin) }
  let(:department)                {
    create(:department,
           title:     'Endocrinology',
           creator:   department_creator,
           hospital:  hospital)
  }

  header 'Host',          'api.gotrailblazer.test'
  header 'Content-Type',  'application/json'
  header 'Authorization', :authorization_header

  get '/v1/departments/:department_slug/clinics' do
    let(:clinics) { create_list(:clinic, 3, department: department) }

    context 'with slug' do
      let(:department_slug) { department.friendly_id }

      context 'as a patient', document: :patient do
        it_behaves_like 'a collection resource', 'clinics' do
          let(:collection) { clinics }
        end

        example 'Get a list' do
          clinics
          create(:doctor, clinic: clinics.last, status: :former)
          create(:nurse,  clinic: clinics.last)
          do_request
        end
      end

      context 'as an admin', document: :admin do
        let(:user) { create(:admin) }

        it_behaves_like 'a collection resource', 'clinics' do
          let(:collection) { clinics }
        end

        example 'Get a list' do
          clinics
          create(:doctor, clinic: clinics.last, status: :former)
          create(:nurse,  clinic: clinics.last)
          do_request
        end
      end
    end
  end

  post '/v1/departments/:department_slug/clinics' do
    with_options scope: :clinic do
      parameter :title,     'Clinic title', required: true
    end

    let(:raw_post) { params.to_json }

    context 'with slug' do
      let(:department_slug) { department.friendly_id }

      context 'as a patient', document: :patient do
        example 'Create a clinic' do
          do_request(clinic: { title: 'Preparing the oven' })

          expect(response_status).to be 201
          expect(response_body).to have_json_path 'clinic'
          expect(response_body).to have_json_path 'clinic/author_id'
          expect(parse_json(response_body, 'clinic/author_id')).to eq user.id
        end
      end

      context 'as an admin', document: :admin do
        let(:user) { create(:admin) }

        example 'Create a clinic' do
          do_request(clinic: { title: 'Preparing the oven' })

          expect(response_status).to be 201
          expect(response_body).to have_json_path 'clinic'
          expect(response_body).to have_json_path 'clinic/author_id'
          expect(parse_json(response_body, 'clinic/author_id')).to eq user.id
        end
      end
    end
  end
end

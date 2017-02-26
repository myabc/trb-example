require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Clinics', type: :api do
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
           title:     'Endocrinology',
           creator:   create(:admin),
           hospital:  hospital)
  }
  let(:clinic) {
    create(:clinic,
           title:       'GUM Clinic',
           department:  department,
           author:      clinic_author)
  }
  let(:clinic_id) { clinic.id }

  header 'Host',          'api.gotrailblazer.test'
  header 'Content-Type',  'application/json'
  header 'Authorization', :authorization_header

  get '/v1/clinics/:clinic_id' do
    before do
      create(:nurse, clinic: clinic, status: :former)
      create(:nurse, clinic: clinic)

      create(:doctor,  clinic: clinic,
                       status: :former)
      create(:doctor,  clinic: clinic)
    end

    context 'as a patient', document: :patient do
      example_request 'Get a clinic' do
        expect(response_status).to be 200
        expect(response_body).to have_json_path 'clinic'
        expect(response_body).to be_json_eql(%({
          "department_id": #{department.id},
          "title": "GUM Clinic",
          "author_id": #{clinic_author.id}
        })).at_path('clinic').excluding('doctors',
                                        'nurses')

        expect(response_body).to have_json_path 'clinic/doctors'
        expect(response_body).to have_json_size(4).at_path('clinic/doctors')

        expect(response_body).to have_json_path 'clinic/nurses'
        expect(response_body).to have_json_size(4).at_path('clinic/nurses')
      end
    end

    context 'as an admin', document: :admin do
      let(:user) { create(:admin) }

      example_request 'Get a clinic' do
        expect(response_status).to be 200
        expect(response_body).to have_json_path 'clinic'
        expect(response_body).to be_json_eql(%({
          "department_id": #{department.id},
          "title": "GUM Clinic",
          "author_id": #{clinic_author.id}
        })).at_path('clinic').excluding('doctors',
                                        'nurses')

        expect(response_body).to have_json_path 'clinic/doctors'
        expect(response_body).to have_json_size(4).at_path('clinic/doctors')

        expect(response_body).to have_json_path 'clinic/nurses'
        expect(response_body).to have_json_size(4).at_path('clinic/nurses')
      end
    end
  end

  patch '/v1/clinics/:clinic_id' do
    with_options scope: :clinic do
      parameter :title,     'Clinic title'
    end

    let(:raw_post) { params.to_json }

    context 'as a patient updating their own clinic', document: :patient do
      let(:clinic_author) { user }

      example 'Update a clinic' do
        do_request(clinic: { title: 'IBD Clinic' })

        expect(response_status).to be 200
        expect(parse_json(response_body, 'clinic/title'))
          .to eq 'IBD Clinic'
      end
    end

    context 'as a patient updating another clinic', document: :patient do
      example 'Authorisation error on update' do
        explanation %(A patient may not update another clinic.)

        do_request(clinic: { title: 'IBD Clinic' })

        expect(response_status).to be 403
        expect(response_body).to have_json_path 'errors'
      end
    end

    context 'as an admin', document: :admin do
      let(:user) { create(:admin) }

      example 'Update a clinic' do
        do_request(clinic: { title: 'IBD Clinic' })

        expect(response_status).to be 200
        expect(response_body).to have_json_path 'clinic'
        expect(parse_json(response_body, 'clinic/title'))
          .to eq 'IBD Clinic'
      end
    end
  end

  delete '/v1/clinics/:clinic_id' do
    context 'as a patient deleting their own clinic', document: :patient do
      let(:clinic_author) { user }

      context 'if the clinic is empty' do
        it_behaves_like 'resource deletion'
      end

      context 'if the clinic has content' do
        before do
          create_list(:nurse, 2, clinic: clinic)
        end

        example_request 'Authorisation error on delete' do
          explanation %(A patient may not delete a clinic with content.)

          expect(response_status).to be 403
          expect(response_body).to have_json_path 'errors'
        end
      end
    end

    context 'as a patient deleting another clinic', document: :patient do
      example_request 'Authorisation error on delete' do
        explanation %(A patient may not delete another clinic.)

        expect(response_status).to be 403
        expect(response_body).to have_json_path 'errors'
      end
    end

    context 'as an admin', document: :admin do
      let(:user) { create(:admin) }

      it_behaves_like 'resource deletion'
    end
  end
end

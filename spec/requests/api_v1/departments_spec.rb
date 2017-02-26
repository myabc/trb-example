require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Departments', type: :api do
  let(:user)                  { create(:patient) }
  let(:authorization_header)  { "Bearer #{generate_access_token_for(user)}" }
  let(:hospital) {
    create(:hospital,
           name:    'University College London Hospital',
           acronym: 'UCLH')
  }
  let(:department_creator)        { create(:admin) }
  let(:department)                {
    create(:department,
           title:     'Infectious Disease',
           published: true,
           creator:   department_creator,
           hospital:  hospital)
  }

  header 'Host',          'api.gotrailblazer.test'
  header 'Content-Type',  'application/json'
  header 'Authorization', :authorization_header

  get '/v1/departments/:department_slug' do
    parameter :include, 'optional resources to embed'

    let(:clinic1) {
      create(:clinic, department: department, author: department_creator)
    }
    let(:clinic2) {
      create(:clinic, department: department, author: department_creator)
    }
    let(:employee_creator) { department_creator }

    before do
      %i(nurse doctor).each do |employee|
        create(employee, clinic: clinic1, status: :current,
                         author: employee_creator)
        create(employee, clinic: clinic1, status: :former,
                         author: employee_creator)
        create(employee, clinic: clinic2, status: :current,
                         author: employee_creator)
        create(employee, clinic: clinic2, status: :former,
                         author: employee_creator)

        create(employee, clinic: clinic1, status: :former)
        create(employee, clinic: clinic2, status: :former)
      end
    end

    context 'with slug' do
      let(:department_slug) { department.friendly_id }

      context 'as a patient who has contributed employees', document: :patient do
        let(:employee_creator) { user }

        example 'Get a department' do
          do_request(include: 'nurses, doctors')

          expect(response_status).to be 200
          expect(response_body).to have_json_path 'department'
          expect(response_body).to be_json_eql(%({
            "self_url": "/api/v1/departments/uclh-infectious-disease",
            "slug": "uclh-infectious-disease",
            "title": "Infectious Disease",
            "creator_id": #{department.creator_id},
            "contact_phones": null,
            "director_name": null,
            "org_code": null,
            "published": true,
            "hospital_id": #{hospital.id}
          })).at_path('department').excluding('clinics',
                                              'nurses',
                                              'doctors')

          expect(response_body).to have_json_path 'department/clinics'
          expect(response_body).to have_json_size(2).at_path('department/clinics')

          expect(response_body).to have_json_path 'department/nurses'
          expect(response_body).to have_json_size(12).at_path('department/nurses')

          expect(response_body).to have_json_path 'department/doctors'
          expect(response_body).to have_json_size(12).at_path('department/doctors')
        end
      end

      context 'as an admin', document: :admin do
        let(:department_creator) { create(:patient) }
        let(:employee_creator) { department_creator }
        let(:user) { create(:admin) }

        example 'Get a department' do
          do_request(include: 'doctors, invalid_resources')

          expect(response_status).to be 200
          expect(response_body).to have_json_path 'department'
          expect(response_body).to be_json_eql(%({
            "self_url": "/api/v1/departments/uclh-infectious-disease",
            "slug": "uclh-infectious-disease",
            "title": "Infectious Disease",
            "creator_id": #{department.creator_id},
            "contact_phones": null,
            "director_name": null,
            "org_code": null,
            "published": true,
            "hospital_id": #{hospital.id}
          })).at_path('department').excluding('clinics',
                                              'doctors')

          expect(response_body).to have_json_path 'department/clinics'
          expect(response_body).to have_json_size(2).at_path('department/clinics')

          expect(response_body).not_to have_json_path 'department/nurses'

          expect(response_body).to have_json_path 'department/doctors'
          expect(response_body).to have_json_size(12).at_path('department/doctors')
        end
      end
    end
  end

  patch '/v1/departments/:department_slug' do
    with_options scope: :department do
      parameter :title, 'Title'
      parameter :director_name, 'Director name'
      parameter :contact_phones, 'Contact phones'
      parameter :clinics, 'Clinics'
      parameter :org_code, 'Organisational code'
      parameter :hospital_id, 'Hospital ID'
      parameter :published, 'Published'
      parameter :department_page_url, 'Department Page URL'
      parameter :number_of_patients, 'Number of Patients'
    end

    let(:raw_post) { params.to_json }

    context 'with slug' do
      let(:department_slug) { department.friendly_id }

      context 'as a patient updating their own department', document: :patient do
        let(:department_creator) { user }

        example 'Update permitted department properties' do
          do_request(department: { title: 'Immunology',
                                   published: false })

          expect(response_status).to be 200
          expect(response_body).to have_json_path 'department'
          expect(parse_json(response_body, 'department/title'))
            .to eq 'Immunology'
          expect(parse_json(response_body, 'department/creator_id'))
            .to eq department_creator.id
        end
      end

      context 'as an admin', document: :admin do
        let(:user) { create(:admin) }

        example 'Update permitted department properties' do
          do_request(department: { title: 'Immunology',
                                   published: false })

          expect(response_status).to be 200
          expect(response_body).to have_json_path 'department'
          expect(parse_json(response_body, 'department/title'))
            .to eq 'Immunology'
          expect(parse_json(response_body, 'department/creator_id'))
            .to eq department_creator.id
        end
      end
    end
  end

  delete '/v1/departments/:department_slug' do
    context 'with slug' do
      let(:department_slug) { department.friendly_id }

      context 'as a patient deleting their own department', document: :patient do
        let(:department_creator) { user }

        context 'if the department is empty' do
          it_behaves_like 'resource deletion'
        end

        context 'if the department has content' do
          before do
            create_list(:doctor, 2, department: department)
            create_list(:nurse,  2, department: department)
          end

          example_request 'Authorisation error on delete' do
            explanation %(A patient may not delete a department if it has content.)

            expect(response_status).to be 403
            expect(response_body).to have_json_path 'errors'
          end
        end
      end

      context 'as an admin', document: :admin do
        let(:user) { create(:admin) }

        it_behaves_like 'resource deletion'
      end
    end
  end
end

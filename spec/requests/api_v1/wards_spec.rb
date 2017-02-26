require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Wards', type: :api do
  let(:user) { create(:patient) }
  let(:ward_creator) { create(:patient) }
  let(:authorization_header) { "Bearer #{generate_access_token_for(user)}" }
  let(:department) { create(:department) }
  let(:ward) {
    create(:ward,
           creator:     ward_creator,
           name:        'Oncology',
           category:    :intensive,
           department:  department)
  }
  let(:ward_id) { ward.id }

  header 'Host',          'api.gotrailblazer.test'
  header 'Content-Type',  'application/json'
  header 'Authorization', :authorization_header

  get '/v1/wards/:ward_id' do
    with_options scope: :ward do
      response_field :id,             'Ward ID'
      response_field :creator,        'Creator'
      response_field :name,           'Ward name'
      response_field :description,    'Description'
      response_field :status,         'Status'
      response_field :created_at,     'Created at'
      response_field :updated_at,     'Updated at'
      response_field :department_id,  'Department ID'
      response_field :category,       'Category'
      response_field :emergency,      'Emergency'
    end

    context 'as a patient', document: :patient do
      example_request 'Get a ward metadata' do
        expect(response_status).to be 200
        expect(response_body).to have_json_path('ward')
        expect(response_body).to be_json_eql(%(
        {
          "name":           "Oncology",
          "creator_id":     #{ward_creator.id},
          "description":    null,
          "department_id":  #{department.id},
          "category":       "intensive",
          "emergency":      false,
          "up_votes_count": 0,
          "url":            null
        })).at_path('ward')

        expect(response_body).to have_json_path('ward/id')
        expect(response_body).to have_json_path('ward/created_at')
        expect(response_body).to have_json_path('ward/updated_at')
      end
    end

    context 'as an admin', document: :admin do
      let(:user) { create(:admin) }

      example_request 'Get a ward metadata' do
        expect(response_status).to be 200
        expect(response_body).to have_json_path('ward')
        expect(response_body).to be_json_eql(%(
        {
          "name":           "Oncology",
          "creator_id":     #{ward_creator.id},
          "description":    null,
          "department_id":  #{department.id},
          "category":       "intensive",
          "emergency":      false,
          "up_votes_count": 0,
          "url":            null
        })).at_path('ward')

        expect(response_body).to have_json_path('ward/id')
        expect(response_body).to have_json_path('ward/created_at')
        expect(response_body).to have_json_path('ward/updated_at')
      end
    end

    context 'as the creator', document: false do
      let(:user) { ward_creator }

      example_request 'Get a ward metadata' do
        expect(response_status).to be 200
        expect(response_body).to have_json_path('ward')
        expect(response_body).to be_json_eql(%(
        {
          "name":           "Oncology",
          "creator_id":     #{ward_creator.id},
          "description":    null,
          "department_id":  #{department.id},
          "category":       "intensive",
          "emergency":      false,
          "up_votes_count": 0,
          "url":            null
        })).at_path('ward')

        expect(response_body).to have_json_path('ward/id')
        expect(response_body).to have_json_path('ward/created_at')
        expect(response_body).to have_json_path('ward/updated_at')
      end
    end
  end

  delete '/v1/wards/:ward_id' do
    context 'as a patient deleting their own ward', document: :patient do
      let(:ward_creator) { user }

      it_behaves_like 'resource deletion'
    end

    context 'as a patient deleting another ward', document: :patient do
      example_request 'Authorisation error on delete' do
        explanation %(A patient may not delete another ward.)

        expect(response_status).to be 403
        expect(response_body).to have_json_path 'errors'
      end
    end

    context 'as an admin', document: :admin do
      let(:user) { create(:admin) }

      it_behaves_like 'resource deletion'
    end
  end

  put '/v1/wards/:ward_id/upvote' do
    example_request 'Upvote a ward' do
      expect(response_status).to be 204
    end
  end

  put '/v1/wards/:ward_id/bookmark' do
    example_request 'Bookmark a ward' do
      expect(response_status).to be 204
    end
  end

  delete '/v1/wards/:ward_id/bookmark' do
    example_request 'Unbookmark a ward' do
      expect(response_status).to be 204
    end
  end
end

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Department Wards', type: :api do
  let(:user)                 { create(:patient) }
  let(:authorization_header) { "Bearer #{generate_access_token_for(user)}" }
  let(:department)               { create(:department) }
  let(:department_id)            { department.id }

  header 'Host',          'api.gotrailblazer.test'
  header 'Content-Type',  'application/json'
  header 'Authorization', :authorization_header

  get '/v1/departments/:department_id/wards' do
    it_behaves_like 'a collection resource', 'wards' do
      let(:collection) {
        create_list(:ward, 3, department: department)
      }
    end
  end

  post '/v1/departments/:department_id/wards' do
    with_options scope: :ward, required: true do
      parameter :category,  'Category: intensive|non_intensive'
      parameter :name,      'Ward name'
      parameter :url,       'URL to the ward'
    end

    with_options scope: :ward do
      parameter :description, 'Description'
      parameter :emergency,   'Emergency (default: false)'
    end

    let(:category)    { 'non_intensive' }
    let(:name)        { 'Best ward in the country' }
    let(:description) { 'Leading medical research in the world  ' }
    let(:url)         { 'http://nhs.uk/ward.pdf' }

    let(:raw_post) { params.to_json }

    example_request 'creates the ward' do
      expect(response_status).to be 201

      expect(response_body).to be_json_eql(%({
        "ward": {
          "department_id": #{department_id},
          "creator_id": #{user.id},
          "up_votes_count": 0,
          "name": "Best ward in the country",
          "description": "Leading medical research in the world",
          "category": "non_intensive",
          "emergency": false,
          "url": null
        }
      })).excluding('creator')
    end
  end
end

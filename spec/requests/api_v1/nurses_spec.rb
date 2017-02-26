require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Nurses', type: :api do
  let(:user)                  { create(:patient) }
  let(:authorization_header)  { "Bearer #{generate_access_token_for(user)}" }
  let(:nurse)                 { create(:nurse, author: user) }
  let(:nurse_id)              { nurse.id }

  header 'Host',          'api.gotrailblazer.test'
  header 'Content-Type',  'application/json'
  header 'Authorization', :authorization_header

  get '/v1/nurses/:nurse_id' do
    example_request 'Get a nurse' do
      expect(response_status).to be 200
      expect(response_body).to have_json_path 'nurse'
      expect(response_body).to be_json_eql %({
        "nurse": {
          "qualifications": [
          ],
          "author_id": #{user.id},
          "clinic_id": #{nurse.clinic_id},
          "downvotes_count": 0,
          "notes": null,
          "notes_html": null,
          "status": "current",
          "upvotes_count": 0
        }
      })
    end
  end

  patch '/v1/nurses/:nurse_id' do
    with_options scope: :nurse do
      parameter :notes_html,      'Notes HTML'
      parameter :qualifications,  'Qualification Options'
      parameter :clinic_id,       'Clinic ID'
    end

    with_options scope: [:nurse, :qualifications] do
      parameter :name,      'Qualification Name'
      parameter :position,  'Qualification Position'
    end

    let(:notes_html) { 'Doing all the work' }
    let(:qualifications) {
      [
        {
          name: 'Qualification 1'
        },
        {
          name: 'Qualification 2'
        }
      ]
    }
    let(:raw_post) { params.to_json }

    example_request 'Update a nurse' do
      expect(response_status).to be 200
      expect(response_body).to have_json_path 'nurse'
      expect(parse_json(response_body, 'nurse/qualifications/1/name'))
        .to eq 'Qualification 2'
    end
  end

  delete '/v1/nurses/:nurse_id' do
    it_behaves_like 'resource deletion'
  end

  put '/v1/nurses/:nurse_id/bookmark' do
    example_request 'Bookmark a nurse' do
      expect(response_status).to be 204
    end
  end

  delete '/v1/nurses/:nurse_id/bookmark' do
    example_request 'Unbookmark a nurse' do
      expect(response_status).to be 204
    end
  end

  put '/v1/nurses/:nurse_id/upvote' do
    example_request 'Upvote a nurse' do
      expect(response_status).to be 204
    end
  end

  put '/v1/nurses/:nurse_id/downvote' do
    example_request 'Downvote a nurse' do
      expect(response_status).to be 204
    end
  end
end

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Doctors', type: :api do
  let(:user)                  { create(:patient) }
  let(:authorization_header)  { "Bearer #{generate_access_token_for(user)}" }
  let(:doctor) {
    create(:doctor,
           author:      user,
           notes:       'Best doctor in the country',
           biography:   'Studied at Johns Hopkins')
  }
  let(:doctor_id) { doctor.id }

  header 'Host',          'api.gotrailblazer.test'
  header 'Content-Type',  'application/json'
  header 'Authorization', :authorization_header

  get '/v1/doctors/:doctor_id' do
    example_request 'Get a doctor' do
      expect(response_status).to be 200
      expect(response_body).to have_json_path 'doctor'
      expect(response_body).to be_json_eql(%({
        "doctor": {
          "author_id": #{user.id},
          "notes": "Best doctor in the country",
          "clinic_id": #{doctor.clinic_id},
          "downvotes_count": 0,
          "biography": "Studied at Johns Hopkins",
          "status": "current",
          "upvotes_count": 0
        }
      })).excluding('notes_html', 'biography_html')
    end
  end

  patch '/v1/doctors/:doctor_id' do
    with_options scope: :doctor do
      parameter :biography,       'Biography Markdown'
      parameter :biography_html,  'Biography HTML'
      parameter :notes,           'Notes Markdown'
      parameter :notes_html,      'Notes HTML'
      parameter :current,         'Published'
      parameter :clinic_id,       'Clinic ID'
    end
  end

  delete '/v1/doctors/:doctor_id' do
    it_behaves_like 'resource deletion'
  end

  put '/v1/doctors/:doctor_id/bookmark' do
    example_request 'Bookmark a doctor' do
      expect(response_status).to be 204
    end
  end

  delete '/v1/doctors/:doctor_id/bookmark' do
    example_request 'Unbookmark a doctor' do
      expect(response_status).to be 204
    end
  end

  put '/v1/doctors/:doctor_id/upvote' do
    example_request 'Upvote a doctor' do
      expect(response_status).to be 204
    end
  end

  put '/v1/doctors/:doctor_id/downvote' do
    example_request 'Downvote a doctor' do
      expect(response_status).to be 204
    end
  end
end

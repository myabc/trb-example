require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Doctor Comments', type: :api do
  let(:user)                  { create(:patient) }
  let(:authorization_header)  { "Bearer #{generate_access_token_for(user)}" }
  let(:doctor)             { create(:doctor, author: user) }
  let(:doctor_id)          { doctor.id }

  header 'Host',          'api.gotrailblazer.test'
  header 'Content-Type',  'application/json'
  header 'Authorization', :authorization_header

  get '/v1/doctors/:doctor_id/comments' do
    let(:thread) { create(:thread, subject: doctor) }

    it_behaves_like 'a collection resource', 'comments' do
      let(:collection) {
        create_list(:comment, 2, thread: thread)
      }
    end
  end

  post '/v1/doctors/:doctor_id/comments' do
    with_options scope: :comment do
      parameter :message, 'Message', required: true
    end

    with_options scope: :comment do
      response_field :id,           'Comment ID'
      response_field :author_id,    'Author ID'
      response_field :message,      'Message'
      response_field :created_at,   'Created at'
      response_field :reply_to_id,  'Reply to Comment ID'
      response_field :replies,      'Replies (Array of Comments)'
    end

    let(:raw_post) { params.to_json }

    context 'creating a top-level comment' do
      context 'with a message' do
        let(:message) { 'This doctor is particularly helpful!' }

        example_request 'Create a comment' do
          expect(response_status).to be 201
          expect(response_body).to have_json_path 'comment'
          expect(response_body).to have_json_path 'comment/replies'
        end
      end

      context 'with a missing message' do
        example_request 'Validation error on create' do
          explanation %(A missing `message` gives a validation error.)

          expect(response_status).to be 422
          expect(response_body).to have_json_path 'errors'
          expect(response_body).to have_json_path 'errors/errors/message'
          expect(response_body).to have_json_type(Array).at_path 'errors/errors/message'
        end
      end
    end
  end
end

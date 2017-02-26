require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Comments', type: :api do
  let(:user)                  { create(:patient) }
  let(:authorization_header)  { "Bearer #{generate_access_token_for(user)}" }
  let(:comment)               { create(:comment) }
  let(:comment_id)            { comment.id }

  header 'Host',          'api.gotrailblazer.test'
  header 'Content-Type',  'application/json'
  header 'Authorization', :authorization_header

  delete '/v1/comments/:comment_id' do
    context 'as a patient deleting their own comment', document: :patient do
      let(:comment) { create(:comment, author: user) }

      it_behaves_like 'resource deletion'
    end

    context 'as a patient deleting another comment', document: :patient do
      let(:comment) { create(:comment) }

      example_request 'Authorisation error on delete' do
        explanation %(A patient may not delete another comment.)

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

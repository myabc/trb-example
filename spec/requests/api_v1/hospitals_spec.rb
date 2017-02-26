require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Hospitals', type: :api do
  let(:user)                  { create(:patient) }
  let(:authorization_header)  { "Bearer #{generate_access_token_for(user)}" }

  header 'Host',          'api.gotrailblazer.test'
  header 'Content-Type',  'application/json'
  header 'Authorization', :authorization_header

  get '/v1/hospitals' do
    it_behaves_like 'a collection resource', 'hospitals' do
      let(:collection) { create_list(:hospital, 3) }
    end
  end

  get '/v1/hospitals/:hospital_slug' do
    let(:hospital) {
      create(:hospital,
             name:    'St Bartholomew\'s Hospital',
             acronym: 'BL',
             url:     'http://bartshealth.nhs.uk/',
             street:  'W Smithfield',
             street_number:  '',
             postal_code:    'EC1A 7BE')
    }

    context 'with slug' do
      let(:hospital_slug) { hospital.friendly_id }

      example_request 'Get a hospital' do
        expect(response_status).to be 200
        expect(response_body).to have_json_path 'hospital'
        expect(response_body).to be_json_eql %({
          "hospital": {
            "self_url": "/api/v1/hospitals/st-bartholomew-s-hospital",
            "slug": "st-bartholomew-s-hospital",
            "name":"St Bartholomew\'s Hospital",
            "acronym": "BL",
            "city": null,
            "country_code": null,
            "postal_code": "EC1A 7BE",
            "street": "W Smithfield",
            "street_number": "",
            "url": "http://bartshealth.nhs.uk/"
          }
        })
      end
    end
  end
end

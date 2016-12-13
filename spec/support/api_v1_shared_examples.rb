RSpec.shared_examples 'a collection resource' do |collection_path|
  let(:collection_size) { collection.size }

  context "with no #{metadata[:resource_name].downcase}", document: false do
    example_request 'Get an empty list' do
      expect(response_status).to be 200
      expect(response_body).to have_json_path collection_path
      expect(response_body).to have_json_size(0).at_path(collection_path)
    end
  end

  context "with #{metadata[:resource_name].downcase}" do
    example "Get a list of #{metadata[:resource_name].downcase}" do
      collection
      do_request

      expect(response_status).to be 200
      expect(response_body).to have_json_path collection_path
      expect(response_body).to have_json_size(collection_size)
        .at_path collection_path
    end
  end
end

RSpec.shared_examples 'resource deletion' do
  example_request "Delete a #{metadata[:resource_name].singularize.downcase}" do
    expect(response_status).to be 204
    expect(response_body).to be_empty
  end
end

require 'rails_helper'

RSpec.describe Commenting::Comment::Report, type: :operation do
  let(:nurse_author) { create(:patient) }
  let(:nurse) { create(:nurse, author: nurse_author) }
  let!(:comment) {
    Commenting::Comment::Create.call({ comment:     { message: 'More ideas' },
                                       nurse_id:  nurse.id,
                                       current_user: nurse_author }
                                      .with_indifferent_access)
                               .model
  }
  subject(:operation) {
    Commenting::Comment::Report.call(id: comment.id,
                                     current_user: nurse_author)
  }

  it 'reports the comment' do
    expect(operation.model).to be_reported
  end
end

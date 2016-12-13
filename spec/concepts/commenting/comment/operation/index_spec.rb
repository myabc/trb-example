require 'rails_helper'

RSpec.describe Commenting::Comment::Index, type: :operation do
  include JsonSpec::Helpers

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
    Commenting::Comment::Index.call(nurse_id:  nurse.id,
                                    current_user: nurse_author)
  }

  before do
    Commenting::Comment::CreateReply.call({ comment:     { message: 'Interesting reply' },
                                            comment_id:   comment.id,
                                            current_user: nurse_author }
                                      .with_indifferent_access)
    Commenting::Comment::CreateReply.call({ comment:     { message: 'Not so interesting reply' },
                                            comment_id:   comment.id,
                                            current_user: nurse_author }
                                      .with_indifferent_access)
  end

  it 'shows the comment' do
    expect(operation.model).to all be_a(Commenting::CommentTreeItem)
    expect(operation.model.first).to eq comment
  end

  it 'renders JSON' do
    expect(operation.to_json).to have_json_path('comments')
    expect(operation.to_json).to have_json_path('comments/0/replies')
    expect(operation.to_json).to have_json_type(Array)
      .at_path('comments/0/replies')
    expect(operation.to_json).to have_json_size(2).at_path('comments/0/replies')
  end
end

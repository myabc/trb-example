require 'rails_helper'

RSpec.describe Commenting::Comment::CreateReply, type: :operation do
  let(:nurse_author) { create(:patient) }
  let(:nurse)        { create(:nurse, author: nurse_author) }
  let(:comment_author) { create(:patient) }
  let!(:reply_to_comment) {
    Commenting::Comment::Create.call({ comment:     { message: 'More ideas' },
                                       nurse_id:  nurse.id,
                                       current_user: nurse_author }
                                      .with_indifferent_access)
                               .model
  }

  context 'with invalid params' do
    subject(:operation) { Commenting::Comment::CreateReply.run(params)[1] }

    let(:params) {
      {
        comment:      {},
        comment_id:   reply_to_comment.id,
        current_user: comment_author
      }.with_indifferent_access
    }

    it 'does not create the reply' do
      expect(operation.model).not_to be_persisted
      expect(operation.contract.errors.messages)
        .to eq(message: ['must be filled'])
    end
  end

  context 'with valid params' do
    subject(:operation) { Commenting::Comment::CreateReply.call(params) }

    let(:params) {
      {
        comment: {
          message: 'Even more ideas from my side.'
        },
        comment_id:   reply_to_comment.id,
        current_user: comment_author
      }.with_indifferent_access
    }

    it 'creates the reply' do
      expect(operation.model).to be_persisted
      expect(operation.model).to have_attributes(
        message:  'Even more ideas from my side.',
        author:   comment_author,
        thread:   reply_to_comment.thread
      )
    end
  end
end

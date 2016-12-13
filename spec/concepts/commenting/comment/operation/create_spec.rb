require 'rails_helper'

RSpec.describe Commenting::Comment::Create, type: :operation do
  let(:nurse_author)    { create(:patient) }
  let(:nurse)           { create(:nurse, author: nurse_author) }
  let(:comment_author)  { create(:patient) }

  context 'with invalid params' do
    subject(:operation) { Commenting::Comment::Create.run(params)[1] }

    context 'with missing comment params' do
      let(:params) {
        {
          comment:      {},
          nurse_id:  nurse.id,
          current_user: comment_author
        }.with_indifferent_access
      }

      it 'does not create the comment' do
        expect(operation.model).not_to be_persisted
        expect(operation.contract.errors.messages).to have_key(:message)
        expect(operation.contract.errors.messages.values[0])
          .to include('must be filled')
      end
    end

    context 'with invalid comment params' do
      let(:params) {
        {
          comment:      {
            message: 'X'
          },
          nurse_id:  nurse.id,
          current_user: comment_author
        }.with_indifferent_access
      }

      it 'does not create the comment' do
        expect(operation.model).not_to be_persisted
        expect(operation.contract.errors.messages)
          .to eq(message: ['size cannot be less than 2'])
      end
    end
  end

  context 'with valid params' do
    subject(:operation) { Commenting::Comment::Create.call(params) }

    let(:params) {
      {
        comment: {
          message: 'Constructive ideas for improvement.'
        },
        nurse_id:  nurse.id,
        current_user: comment_author
      }.with_indifferent_access
    }

    it 'creates the comment' do
      expect(operation.model).to be_persisted
      expect(operation.model).to have_attributes(
        message:  'Constructive ideas for improvement.',
        author:   comment_author
      )
    end

    it 'creates a new thread' do
      thread = operation.model.thread

      expect(thread).to be_persisted
      expect(thread.subject.id).to eq nurse.id
    end
  end
end

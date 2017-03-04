require 'rails_helper'

RSpec.describe Commenting::Comment::Delete, type: :operation do
  let(:nurse_author) { create(:patient) }
  let(:nurse) { create(:nurse, author: nurse_author) }
  let!(:comment) {
    Commenting::Comment::Create.call({
                                       comment:   { message: 'More ideas' },
                                       nurse_id:  nurse.id
                                     },
                                     'current_user' => nurse_author)['model']
  }
  subject(:operation) {
    Commenting::Comment::Delete.call({ id: comment.id },
                                     'current_user' => nurse_author)
  }

  it 'deletes the comment' do
    expect { operation['model'].reload }
      .to raise_error(ActiveRecord::RecordNotFound)
  end
end

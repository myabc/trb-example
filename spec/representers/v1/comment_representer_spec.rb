require 'rails_helper'

RSpec.describe V1::CommentRepresenter do
  let(:representer) { V1::CommentRepresenter.new(comment) }

  context 'generation' do
    let(:comment)       { build(:comment) }
    let(:user_options)  { {} }
    subject(:output)    { representer.to_json(user_options: user_options) }

    it { is_expected.to have_json_path('comment/id') }
    it { is_expected.to have_json_path('comment/author_id') }
    it { is_expected.to have_json_path('comment/reply_to_id') }
    it { is_expected.to have_json_path('comment/message') }
    it { is_expected.to have_json_path('comment/created_at') }
    it { is_expected.to have_json_path('comment/status') }

    context 'without include_replies' do
      it { is_expected.not_to have_json_path('comment/replies') }
    end

    context 'with include_replies' do
      let(:user_options) { { include_replies: true } }

      it { is_expected.to have_json_path('comment/replies') }
      it { is_expected.to have_json_type(Array).at_path('comment/replies') }
    end

    context 'without curated' do
      it { is_expected.not_to have_json_path('comment/subject_id') }
    end

    context 'with curated' do
      let(:user_options) { { curated: true } }

      it { is_expected.to have_json_path('comment/subject_id') }
      it { is_expected.to have_json_type(Integer).at_path('comment/subject_id') }
      it { is_expected.to have_json_path('comment/subject_type') }
    end
  end

  context 'parsing' do
    let(:json) {
      %(
        {
          "comment": {
            "message": "An interesting nurse.",
            "author_id": "69",
            "reply_to_id": "99"
          }
        }
      )
    }
    let(:comment)     { Commenting::Comment.new }
    subject(:object)  { representer.from_json(json) }

    it 'sets writeable attributes' do
      expect(object.message).to eq 'An interesting nurse.'
    end

    it 'does not set non-writeable attributes' do
      expect(object.author_id).to be nil
      expect(object.reply_to_id).to be nil
    end
  end
end

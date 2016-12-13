require 'rails_helper'

RSpec.describe V1::CommentsRepresenter do
  let(:collection)    { build_list(:comment, 2, :with_replies, replies_count: 2) }
  let(:representer)   { V1::CommentsRepresenter.new(collection) }
  let(:user_options)  { {} }
  subject(:output)    { representer.to_json(user_options: user_options) }

  it { is_expected.to have_json_path('comments') }
  it { is_expected.to have_json_type(Array).at_path('comments') }
  it { is_expected.to have_json_size(2).at_path('comments') }

  it { is_expected.to have_json_path('comments/1/id') }

  context 'with explicit nil user_options' do
    let(:user_options) { nil }

    it { is_expected.not_to have_json_path('comments/1/replies') }
  end

  context 'without include_replies' do
    it { is_expected.not_to have_json_path('comments/1/replies') }
  end

  context 'with include_replies' do
    let(:user_options) { { include_replies: true } }

    it { is_expected.to have_json_path('comments/1/replies') }
    it { is_expected.to have_json_type(Array).at_path('comments/1/replies') }
  end
end

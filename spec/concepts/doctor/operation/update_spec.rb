require 'rails_helper'
require_relative './shared_contexts'

RSpec.describe Doctor::Update, type: :operation do
  include_context 'with an existing former doctor'

  subject(:operation) { Doctor::Update.call(params) }

  context 'with valid params' do
    let(:current_user) { patient_author }

    let(:params) {
      {
        doctor: {
          biography:      'He began his studies in Cambridge in 1990.',
          biography_html: '<p>He began his studies in Cambridge in 1990.</p>',
          notes:          'One of the best brain surgeons in the EU.',
          notes_html:     '<p>One of the best brain surgeons in the EU.</p>'
        },
        id:           doctor.id,
        current_user: current_user
      }.with_indifferent_access
    }

    context 'as a patient' do
      it 'updates the doctor' do
        expect(operation.model.biography)
          .to eq 'He began his studies in Cambridge in 1990.'
        expect(operation.model.notes_html)
          .to eq '<p>One of the best brain surgeons in the EU.</p>'
      end
    end

    context 'as an admin' do
      let(:current_user) { create(:admin) }

      it 'updates the doctor' do
        expect(operation.model.biography)
          .to eq 'He began his studies in Cambridge in 1990.'
        expect(operation.model.notes_html)
          .to eq '<p>One of the best brain surgeons in the EU.</p>'
      end
    end
  end

  context 'with valid params' do
    let(:other_clinic)  { create(:clinic, author: patient_author) }
    let(:other_author)  { create(:patient) }
    let(:current_user)  { patient_author }

    let(:params) {
      {
        doctor: {
          biography:      'He began his studies in Cambridge in 1990.',
          biography_html: '<p>He began his studies in Cambridge in 1990.</p>',
          notes:          'One of the best brain surgeons in the EU.',
          notes_html:     '<p>One of the best brain surgeons in the EU.</p>',
          status:         'current',
          clinic_id:      other_clinic.id,
          author_id:      other_author.id
        },
        id:           doctor.id,
        current_user: current_user
      }.with_indifferent_access
    }

    context 'as a patient' do
      it 'updates the doctor' do
        expect(operation.model.biography)
          .to eq 'He began his studies in Cambridge in 1990.'
        expect(operation.model.notes_html)
          .to eq '<p>One of the best brain surgeons in the EU.</p>'
      end

      it "updates the doctor's status" do
        expect(operation.model).to be_current
      end

      it "does not update the doctor's author" do
        expect(operation.model.author).to eq patient_author
      end

      it "does not update the doctor's clinic" do
        expect(operation.model.clinic).to eq clinic
      end
    end

    context 'as an admin' do
      let(:current_user) { create(:admin) }

      it 'updates the doctor' do
        expect(operation.model.biography)
          .to eq 'He began his studies in Cambridge in 1990.'
        expect(operation.model.notes_html)
          .to eq '<p>One of the best brain surgeons in the EU.</p>'
      end

      it "updates the doctor's status" do
        expect(operation.model).to be_current
      end

      it "updates the doctor's author" do
        expect(operation.model.author).to eq other_author
      end

      it "updates the doctor's clinic" do
        expect(operation.model.clinic).to eq other_clinic
      end
    end
  end
end

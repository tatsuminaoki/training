# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    let(:name) { 'test' }
    describe 'column:authority' do
      let(:authority) { 1 }
      subject { described_class.create(name: name, authority: authority) }
      context 'Valid value' do
        it 'Create correctly' do
          expect(subject).to be_valid
          expect(subject.errors[:authority].count).to eq 0
        end
      end
      context 'Nil value' do
        let(:authority) { nil }
        it 'Return error correctly' do
          expect(subject).not_to be_valid
          expect(subject.errors[:authority][0]).to eq I18n.t(:errors)[:messages][:blank]
        end
      end
      context 'Invalid value' do
        let(:authority) { User.authorities.keys.count + 1 }
        it 'Return error correctly' do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end
  end
end

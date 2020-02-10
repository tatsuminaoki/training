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
        let(:authority) { ValueObjects::Authority.get_list.count + 1 }
        it 'Return error correctly' do
          expect(subject).not_to be_valid
          expect(subject.errors[:authority][0]).to eq I18n.t(:errors)[:messages][:inclusion]
        end
      end
    end
  end
end

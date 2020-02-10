require 'rails_helper'

RSpec.describe Login, type: :model do
  describe '#create' do
    let!(:user_a) { create(:user1) }
    let(:user_id) { user_a.id}
    let(:email) { 'rspec@example.com' }
    let(:password) { 'password' }
    subject { described_class.create(user_id: user_id, email: email, password: password) }
    describe 'columun:user_id' do
      context 'Valid value' do
        it 'Create correctly' do
          expect(subject).to be_valid
          expect(subject.errors[:user_id].count).to eq 0
        end
      end
      context 'Nil value' do
        let(:user_id) { nil }
        it 'Return error correctly' do
          expect(subject).not_to be_valid
          expect(subject.errors[:user_id][0]).to eq I18n.t(:errors)[:messages][:blank]
        end
      end
      context 'Invalid value' do
        let(:user_id) { 'test' }
        it 'Return error correctly' do
          expect(subject).not_to be_valid
          expect(subject.errors[:user_id][0]).to eq I18n.t(:errors)[:messages][:not_a_number]
        end
      end
    end
    describe 'columun:email' do
      context 'Valid value' do
        it 'Create correctly' do
          expect(subject).to be_valid
          expect(subject.errors[:email].count).to eq 0
        end
      end
      context 'Nil value' do
        let(:email) { nil }
        it 'Return error correctly' do
          expect(subject).not_to be_valid
          expect(subject.errors[:email][0]).to eq I18n.t(:errors)[:messages][:blank]
        end
      end
      context 'Invalid value' do
        let(:email) { 'test' }
        it 'Return error correctly' do
          expect(subject).not_to be_valid
          expect(subject.errors[:email][0]).to eq I18n.t(:errors)[:messages][:invalid]
        end
      end
      context 'Duplicate value' do
        let!(:user_b) { create(:user1) }
        let!(:login_b) { create(:login1, user_id: user_a.id, email: 'rspec2@example.com') }
        let(:email) { login_b.email }
        it 'Return error correctly' do
          expect(subject).not_to be_valid
          expect(subject.errors[:email][0]).to eq I18n.t(:errors)[:messages][:taken]
        end
      end
    end
  end
end

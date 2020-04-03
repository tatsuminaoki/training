require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'バリデーション' do
    describe '名前' do
      let(:user) { FactoryBot.create(:user, email: 'label@example.com') }
      let(:label) { FactoryBot.build(:label, name: name, user: user) }
      subject { label }

      context '0文字の場合' do
        let(:name) { '' }
        it { is_expected.to be_invalid }
      end

      context '15文字の場合' do
        let(:name) { 'a' * 15 }
        it { is_expected.to be_valid }
      end

      context '16文字の場合' do
        let(:name) { 'a' * 16 }
        it { is_expected.to be_invalid }
      end

      context '名前が重複した場合' do
        let!(:duplicate_label) { FactoryBot.create(:label, name: 'aaa', user: user) }
        let(:name) { 'aaa' }
        it { is_expected.to be_invalid }
      end
    end
  end
end

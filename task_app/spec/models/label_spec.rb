# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :model do
  describe 'validation' do
    let!(:user) { FactoryBot.create(:user) }

    context '正常値のとき' do
      it { expect(FactoryBot.build(:label, user: user)).to be_valid }
    end

    describe 'ラベル名' do
      let!(:label) { FactoryBot.build(:label, name: name, user: user) }
      subject { label }

      context '空のとき' do
        let(:name) { '' }
        it { is_expected.to be_invalid }
      end

      context '1文字のとき' do
        let(:name) { 'a' }
        it { is_expected.to be_valid }
      end

      context '10文字のとき' do
        let(:name) { 'a' * 10 }
        it { is_expected.to be_valid }
      end

      context '11文字のとき' do
        let(:name) { 'a' * 11 }
        it { is_expected.to be_invalid }
      end

      context '登録済みのラベル名のとき' do
        let!(:duplicate_label) { FactoryBot.create(:label, user: user) }
        let(:name) { duplicate_label.name }
        it { is_expected.to be_invalid }
      end

      context '他のユーザが登録したラベル名のとき' do
        let!(:other_user) { FactoryBot.create(:user, email: 'otheruser@example.com') }
        let!(:other_user_label) { FactoryBot.create(:label, name: 'other', user: other_user) }
        let(:name) { other_user_label.name }
        it { is_expected.to be_valid }
      end
    end
  end
end

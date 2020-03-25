# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '名前' do
    let(:user) { FactoryBot.build(:user, name: name) }
    subject { user }

    context 'nilの場合は無効である' do
      let(:name) { nil }
      it { is_expected.to be_invalid }
    end

    context '0文字の場合は無効である' do
      let(:name) { '' }
      it { is_expected.to be_invalid }
    end

    context '30文字の場合は有効である' do
      let(:name) { 'a' * 30 }
      it { is_expected.to be_valid }
    end

    context '31文字の場合は無効である' do
      let(:name) { 'a' * 31 }
      it { is_expected.to be_invalid }
    end
  end

  describe 'メールアドレス' do
    let(:user) { FactoryBot.build(:user, email: email) }
    subject { user }

    context 'nilの場合は無効である' do
      let(:email) { nil }
      it { is_expected.to be_invalid }
    end

    context '0文字の場合は無効である' do
      let(:email) { '' }
      it { is_expected.to be_invalid }
    end

    context '存在する場合は有効である' do
      let(:email) { 'admin@example.com' }
      it { is_expected.to be_valid }
    end

    context '重複したメールアドレスは無効である' do
      before do
        FactoryBot.create(:user, email: email)
      end

      let(:email) { 'admin@example.com' }
      it { is_expected.to be_invalid }
    end
  end

  describe 'パスワード' do
    let(:user) { FactoryBot.build(:user, password: password) }
    subject { user }

    context 'nilの場合は無効である' do
      let(:password) { nil }
      it { is_expected.to be_invalid }
    end

    context '0文字の場合は無効である' do
      let(:password) { '' }
      it { is_expected.to be_invalid }
    end

    context '3文字の場合は無効である' do
      let(:password) { 'a' * 3 }
      it { is_expected.to be_invalid }
    end

    context '4文字の場合は有効である' do
      let(:password) { 'a' * 4 }
      it { is_expected.to be_valid }
    end
  end
end

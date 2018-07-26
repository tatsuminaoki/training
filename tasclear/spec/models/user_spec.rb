# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    let(:name) { 'ほげ' }
    let(:email) { 'hoge@sample.com' }
    let(:password_digest) { 'password' }
    let(:user) { build(:user, name: name, email: email, password_digest: password_digest) }
    subject { user }

    context '有効' do
      context '名前、メールアドレス、パスワードが指定される' do
        it { is_expected.to be_valid }
      end

      context '名前が30文字' do
        let(:name) { 'あ' * 30 }
        it { is_expected.to be_valid }
      end

      context 'メールアドレスが255文字' do
        let(:email) { 'a@a.' + 'a' * 251 }
        it { is_expected.to be_valid }
      end

      context 'パスワードが6文字' do
        let(:password_digest) { 'a' * 6 }
        it { is_expected.to be_valid }
      end

      context 'パスワードが30文字' do
        let(:password_digest) { 'a' * 30 }
        it { is_expected.to be_valid }
      end
    end

    context '無効' do
      context '名前が指定されない' do
        let(:name) { '' }
        it { is_expected.to be_invalid }
      end

      context '名前が31文字' do
        let(:name) { 'あ' * 31 }
        it { is_expected.to be_invalid }
      end

      context 'メールアドレスが指定されない' do
        let(:email) { '' }
        it { is_expected.to be_invalid }
      end

      context 'メールアドレスが重複' do
        before do
          create(:user, email: email)
        end
        it { is_expected.to be_invalid }
      end

      context 'メールアドレスが正しい形式ではない' do
        let(:email) { 'hogehoge' }
        it { is_expected.to be_invalid }
      end

      context 'メールアドレスが256文字' do
        let(:email) { 'a@a.' + 'a' * 252 }
        it { is_expected.to be_invalid }
      end

      context 'パスワードが指定されない' do
        let(:password_digest) { '' }
        it { is_expected.to be_invalid }
      end

      context 'パスワードが5文字' do
        let(:password_digest) { 'a' * 5 }
        it { is_expected.to be_invalid }
      end

      context 'パスワードが31文字' do
        let(:password_digest) { 'a' * 31 }
        it { is_expected.to be_invalid }
      end
    end
  end
end

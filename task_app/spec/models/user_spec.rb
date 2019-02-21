# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  describe 'validation' do
    context '正常値のとき' do
      it { expect(FactoryBot.build(:user)).to be_valid }
    end

    describe 'メールアドレス' do
      let!(:user) { FactoryBot.build(:user, email: email) }
      subject { user }

      context '空のとき' do
        let(:email) { '' }
        it { is_expected.to be_invalid }
      end

      context '登録済みのメールアドレスのとき' do
        let!(:duplicate_user) { FactoryBot.create(:user) }
        let(:email) { duplicate_user.email }
        it { is_expected.to be_invalid }
      end

      context '意味のない文字列のとき' do
        let(:email) { 'abc123' }
        it { is_expected.to be_invalid }
      end

      context 'アカウント + @のとき' do
        let(:email) { 'test@' }
        it { is_expected.to be_invalid }
      end

      context '@ + ドメインのとき' do
        let(:email) { '@example.com' }
        it { is_expected.to be_invalid }
      end

      context '@がないとき' do
        let(:email) { 'testexample.com' }
        it { is_expected.to be_invalid }
      end

      context '.comがないとき' do
        let(:email) { 'test@example' }
        it { is_expected.to be_invalid }
      end

      context '先頭に空白が含まれるとき' do
        let(:email) { ' test@example.com' }
        it { is_expected.to be_invalid }
      end

      context '末尾に空白が含まれるとき' do
        let(:email) { 'test@example.com ' }
        it { is_expected.to be_invalid }
      end
    end

    describe 'パスワード' do
      let!(:user) { FactoryBot.build(:user, password: password) }
      subject { user }

      context '空のとき' do
        let(:password) { '' }
        it { is_expected.to be_invalid }
      end

      context '6文字未満のとき' do
        let(:password) { 'pass1' }
        it { is_expected.to be_invalid }
      end

      context '6文字のとき' do
        let(:password) { 'pass12' }
        it { is_expected.to be_valid }
      end

      context '空白が含まれるとき' do
        let(:password) { 'pa s12' }
        it { is_expected.to be_invalid }
      end
    end
  end

  describe 'has_many :tasks, dependent: :delete_all' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task1) { FactoryBot.create(:task, user: user) }
    let!(:task2) { FactoryBot.create(:task, user: user) }

    context 'ユーザを削除したとき' do
      it '削除されたユーザのタスクも削除される' do
        expect(User.count).to eq 1
        expect(Task.where(user_id: user.id).count).to eq 2
        user.destroy
        expect(User.count).to eq 0
        expect(Task.where(user_id: user.id).empty?).to eq true
      end
    end
  end

  describe '検索機能' do
    let!(:user1) { FactoryBot.create(:user, email: 'test1@gmail.com') }
    let!(:user2) { FactoryBot.create(:user, email: 'test2@gmail.com') }
    let!(:user3) { FactoryBot.create(:user, email: 'foo@gmail.com') }

    context '「test」でアドレス検索したとき' do
      it '2件のレコードを取得' do
        expect(User.search({ email: 'test' }).count).to eq 2
      end
    end

    context '存在しないアドレスで検索したとき' do
      it '0件のレコードを取得' do
        expect(User.search({ email: 'abc' }).count).to eq 0
      end
    end
  end

  describe '管理者数制御機能' do
    let!(:user1) { FactoryBot.create(:user, email: 'user1@example.com') }
    let!(:user2) { FactoryBot.create(:user, email: 'user2@example.com') }

    context 'user2の権限を一般に更新したとき' do
      it '正常に更新される' do
        expect(user2.update(role: :general)).to eq true
      end
    end

    context 'user2->user1の順で権限を一般に更新したとき' do
      it 'user1の権限は更新できない' do
        expect(user2.update(role: :general)).to eq true
        expect(user1.update(role: :general)).to eq false
      end
    end
  end
end

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'dependent destroy' do
    context 'ユーザーが削除された場合' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:task) { FactoryBot.create(:task, user_id: user.id) }

      it '紐づいているタスクも削除される' do
        expect(Task.find(task.id)).to eq task
        user.destroy
        expect{ Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'validation' do
    describe 'name' do
      let(:user) { FactoryBot.build(:user, name: name) }
      subject { user.valid? }

      context '入力が正しい場合' do
        let(:name) { 'test' }
        it { is_expected.to be true }
      end

      context '空欄の場合' do
        let(:name) { '' }
        it { is_expected.to be false }
      end

      context '文字列の長さ' do
        context '254以下の場合' do
          let(:name) { 'a' * 254 }
          it { is_expected.to be true }
        end

        context '255の場合' do
          let(:name) { 'a' * 255 }
          it { is_expected.to be true }
        end

        context '256以上の場合' do
          let(:name) { 'a' * 256 }
          it { is_expected.to be false }
        end
      end
    end

    describe 'email' do
      let(:user) { FactoryBot.build(:user, email: email) }
      subject { user.valid? }

      context '入力が正しい場合' do
        let(:email) { 'test@example.com' }
        it { is_expected.to be true }
      end

      context '重複する入力の場合' do
        let!(:user_email) { FactoryBot.create(:user) }
        let(:email) { user_email.email }
        it { is_expected.to be false }
      end

      context '空欄の場合' do
        let(:email) { '' }
        it { is_expected.to be false }
      end

      context 'emailのフォーマット' do
        context '正しいメールアドレスの場合' do
          let(:email) { 'test@example.com' }
          it { is_expected.to be true }
        end

        context '単純な文字列の場合' do
          let(:email) { 'aaaa' }
          it { is_expected.to be false }
        end

        context 'ローカル部が存在しない場合' do
          let(:email) { '@aaa.com' }
          it { is_expected.to be false }
        end

        context 'ドメイン部が不完全な場合' do
          let(:email) { 'aaaa@aaa' }
          it { is_expected.to be false }
        end

        context '空白が含まれる場合' do
          let(:email) { 'test@aaa.com ' }
          it { is_expected.to be false }
        end
      end

      context '文字列の長さ' do
        context '254以下の場合' do
          let(:email) { "#{'a' * (254 - 12)}@example.com" }
          it { is_expected.to be true }
        end

        context '255の場合' do
          let(:email) { "#{'a' * (255 - 12)}@example.com" }
          it { is_expected.to be true }
        end

        context '256以上の場合' do
          let(:email) { "#{'a' * (256 - 12)}@example.com" }
          it { is_expected.to be false }
        end
      end
    end

    describe 'password' do
      let(:user) { FactoryBot.build(:user, password: password) }
      subject { user.valid? }

      context '入力が正しい場合' do
        let(:password) { 'test1234' }
        it { is_expected.to be true }
      end

      context '空欄の場合' do
        let(:password) { '' }
        it { is_expected.to be false }
      end

      context 'フォーマット' do
        context '半角英数字のみの場合' do
          let(:password) { 'test1234' }
          it { is_expected.to be true }
        end

        context '記号を含む場合' do
          let(:password) { 'test1234!' }
          it { is_expected.to be false }
        end

        context '全角文字を含む場合' do
          let(:password) { 'パスワードtest' }
          it { is_expected.to be false }
        end
      end

      context '文字列の長さ' do
        context '最小文字数' do
          context '7以下の場合' do
            let(:password) { 'a' * 7 }
            it { is_expected.to be false }
          end

          context '8の場合' do
            let(:password) { 'a' * 8 }
            it { is_expected.to be true }
          end

          context '9以上の場合' do
            let(:password) { 'a' * 9 }
            it { is_expected.to be true }
          end
        end

        # has_secure_passwordは標準で最大文字数:72 を検証する
        context '最大文字数' do
          context '71以下の場合' do
            let(:password) { 'a' * 71 }
            it { is_expected.to be true }
          end

          context '72の場合' do
            let(:password) { 'a' * 72 }
            it { is_expected.to be true }
          end

          context '73以上の場合' do
            let(:password) { 'a' * 73 }
            it { is_expected.to be false }
          end
        end       
      end
    end
  end
end

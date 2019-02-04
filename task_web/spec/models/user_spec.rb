# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ユーザモデルのテスト', type: :model do
  describe 'ユーザ' do
    context 'データ初期化時' do
      let!(:user) { build(:user) }
      it '有効であること' do
        expect(user).to be_valid
      end
    end
    context 'ユーザ名がない時' do
      let!(:user) { build(:user, name: nil) }
      it '無効であること' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to eq ['ユーザ名 が空です']
      end
    end
    context 'メアドがない時' do
      let!(:user) { build(:user, email: nil) }
      it '無効であること' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to eq ['メールアドレス が空です']
      end
    end
    context 'パスワードがない時' do
      let!(:user) { build(:user, password: nil) }
      it '無効であること' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to eq ['パスワード が空です']
      end
    end
    context '権限レベルがない時' do
      let!(:user) { build(:user, auth_level: nil) }
      it '無効であること' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages[0]).to eq '権限 が空です'
        expect(user.errors.full_messages[1]).to eq '権限 が不正です'
      end
    end
    context 'ユーザ名の文字数制限数以上の時' do
      let!(:user) { build(:user, name: ('1' * 21)) }
      it '無効であること' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to eq ['ユーザ名 は20文字以下に設定して下さい。']
      end
    end
    context 'メールアドレスの以外の文字列を入力した時' do
      let!(:user) { build(:user, email: 'test') }
      it '無効であること' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to eq ['メールアドレス が不正です']
      end
    end
    context 'パスワードの文字数制限数以上の時' do
      let!(:user) { build(:user, password: ('1' * 129)) }
      it '無効であること' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to eq ['パスワード は128文字以下に設定して下さい。']
      end
    end
    context 'パスワードの文字数制限数以上の時' do
      let!(:user) { build(:user, password: ('1' * 129)) }
      it '無効であること' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to eq ['パスワード は128文字以下に設定して下さい。']
      end
    end
  end
end

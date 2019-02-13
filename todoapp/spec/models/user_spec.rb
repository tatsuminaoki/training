require 'rails_helper'

describe User, type: :model do
  describe '名前のバリデーションチェック' do
    context '何も入力されてない時' do
      example 'エラーになる' do
        user = build(:user, name: '')
        expect(user).to be_invalid
      end
    end
    context '1文字入力されてる時' do
      example '登録可能' do
        user = build(:user, name: '1')
        expect(user).to be_valid
      end
    end
    context '12文字入力されてる時' do
      example '登録可能' do
        user = build(:user, name: 'a' * 12)
        expect(user).to be_valid
      end
    end
    context '13文字入力されてる時' do
      example 'エラーになる' do
        user = build(:user, name: 'a' * 13)
        expect(user).to be_invalid
      end
    end
  end

  describe 'パスワードのバリデーションチェック' do
    context '何も入力されてない時' do
      example 'エラーになる' do
        user = build(:user, password: '')
        expect(user).to be_invalid
      end
    end
    context '1文字入力されてる時' do
      example '登録可能' do
        user = build(:user, password: '1')
        expect(user).to be_valid
      end
    end
    context '72文字入力されてる時' do
      example '登録可能' do
        user = build(:user, password: 'a' * 72)
        expect(user).to be_valid
      end
    end
    context '73文字入力されてる時' do
      example 'エラーになる' do
        user = build(:user, password: 'a' * 73)
        expect(user).to be_invalid
      end
    end
  end

  describe 'メールアドレスのバリデーションチェック' do
    context '何も入力されてない時' do
      example 'エラーになる' do
        user = build(:user, email: '')
        expect(user).to be_invalid
      end
    end
    context 'メールアドレスじゃないっぽいのが入力された時' do
      example 'エラーになる' do
        user = build(:user, email: 'へいへい')
        expect(user).to be_invalid
      end
    end
    context 'メールアドレスっぽいのが入力された時' do
      example '登録可能' do
        user = build(:user, email: 'rspec@hoge.com')
        expect(user).to be_valid
      end
    end
    context '128文字入力されてる時' do
      example '登録可能' do
        user = build(:user, email: 'a' * 124 + '@a.a')
        expect(user).to be_valid
      end
    end
    context '129文字入力されてる時' do
      example 'エラーになる' do
        user = build(:user, email: 'a' * 125 + '@a.a')
        expect(user).to be_invalid
      end
    end
    context '重複したメールアドレスだったら...' do
      example 'エラーになる' do
        user_a = create(:user, email: 'rspec@hoge.com')
        user_b = build(:user, email: 'rspec@hoge.com')
        expect(user_a).to be_valid
        expect(user_b).to be_invalid
      end
    end
  end
end

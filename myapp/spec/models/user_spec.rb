# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ログインIDのバリデーション' do
    before do
      user = FactoryBot.attributes_for(:user)
      @user = User.new(user)
    end

    context '100文字な場合' do
      it '登録できる' do
        @user.login_id = 'a' * 100
        expect(@user).to be_valid
      end
    end

    context '101文字な場合' do
      it 'エラーになる' do
        @user.login_id = 'a' * 101
        expect(@user).not_to be_valid
      end
    end

    context '半角英数字のみな場合' do
      it '登録できる' do
        @user.login_id = 'abcABC0123'
        expect(@user).to be_valid
      end
    end

    context '半角英数字以外な場合' do
      it 'エラーになる' do
        @user.login_id = 'kigou$ha^dame,napattern'
        expect(@user).not_to be_valid
        @user.login_id = '日本語もだめなパターン'
        expect(@user).not_to be_valid
      end
    end

    context '重複したログインIDの場合' do
      it 'エラーになる' do
        create(:user, login_id: 'hoge')
        duplicate_user = FactoryBot.attributes_for(:user, login_id: 'hoge')
        user = User.new(duplicate_user)
        user.valid?
        expect(user.errors[:login_id]).to include('はすでに存在します')
      end
    end
  end

  describe 'パスワードのバリデーション' do
    before do
      user = FactoryBot.attributes_for(:user)
      @user = User.new(user)
    end

    context '100文字な場合' do
      it '登録できる' do
        @user.password_digest = 'abcA1' * 20
        expect(@user).to be_valid
      end
    end

    context '101文字な場合' do
      it 'エラーになる' do
        @user.password_digest = 'a' * 101
        expect(@user).not_to be_valid
      end
    end

    context '半角英小文字大文字数字をそれぞれ1種類以上含む場合' do
      it '登録できる' do
        @user.password_digest = 'abcABC0123'
        expect(@user).to be_valid
      end
    end

    context '半角英小文字大文字数字をそれぞれ1種類以上含んでいない場合' do
      it 'エラーになる' do
        @user.password_digest = 'Kigou-Ga-Fukumareteiru123'
        expect(@user).not_to be_valid
        @user.password_digest = '日本語もだめなパターン'
        expect(@user).not_to be_valid
        @user.password_digest = 'SuujiGaFukumareteinai'
        expect(@user).not_to be_valid
        @user.password_digest = 'oomojigafukumareteinai123'
        expect(@user).not_to be_valid
        @user.password_digest = 'KOMOJIGAFUKUMARETEINAI123'
        expect(@user).not_to be_valid
      end
    end
  end
end

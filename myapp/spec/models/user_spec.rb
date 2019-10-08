# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ログインIDのバリデーション' do
    let(:user) { User.new(FactoryBot.attributes_for(:user)) }

    context '100文字な場合' do
      it '登録できる' do
        user.login_id = 'a' * 100
        expect(user).to be_valid
      end
    end

    context '101文字な場合' do
      it 'エラーになる' do
        user.login_id = 'a' * 101
        expect(user).not_to be_valid
      end
    end

    context '半角英数字のみな場合' do
      it '登録できる' do
        user.login_id = 'abcABC0123'
        expect(user).to be_valid
      end
    end

    context '半角英数字以外な場合' do
      it 'エラーになる' do
        user.login_id = 'kigou$ha^dame,napattern'
        expect(user).not_to be_valid
        user.login_id = '日本語もだめなパターン'
        expect(user).not_to be_valid
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
    let(:user) { User.new(FactoryBot.attributes_for(:user)) }

    context '100文字な場合' do
      it '登録できる' do
        password = 'abcA1' * 20
        user.password = password
        user.password_confirmation = password
        expect(user).to be_valid
      end
    end

    context '101文字な場合' do
      it 'エラーになる' do
        password = 'a' * 101
        user.password = password
        user.password_confirmation = password
        expect(user).not_to be_valid
      end
    end

    context '半角英小文字大文字数字をそれぞれ1種類以上含む場合' do
      it '登録できる' do
        password = 'abcABC0123'
        user.password = password
        user.password_confirmation = password
        expect(user).to be_valid
      end
    end

    context '記号を含んでいる場合' do
      it 'エラーになる' do
        user.password = 'Kigou-Ga-Fukumareteiru123'
        expect(user).not_to be_valid
      end
    end

    context '日本語を含んでいる場合' do
      it 'エラーになる' do
        user.password = '日本語もだめなパターン'
        expect(user).not_to be_valid
      end
    end

    context '数字が含まれていない場合' do
      it 'エラーになる' do
        user.password = 'SuujiGaFukumareteinai'
        expect(user).not_to be_valid
      end
    end

    context '大文字が含まれていない場合' do
      it 'エラーになる' do
        user.password = 'oomojigafukumareteinai123'
        expect(user).not_to be_valid
      end
    end

    context '小文字が含まれていない場合' do
      it 'エラーになる' do
        user.password = 'KOMOJIGAFUKUMARETEINAI123'
        expect(user).not_to be_valid
      end
    end
  end
end

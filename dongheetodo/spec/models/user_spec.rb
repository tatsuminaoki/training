require 'rails_helper'
require 'faker'
require 'factory_bot'

describe 'User' do
  describe '#create' do
    context '有効な値を与えた場合' do
      it '正常に生成すること' do
        email = Faker::Internet.email
        password = Faker::Internet.password(min_length: 8, max_length: 20)
        user = User.new(email: email, password: password)
        expect(user.save!).to be_truthy
      end
    end

    ### メールアドレス

    context 'メールアドレスを与えなかった場合' do
      it 'エラーが発生すること' do
        email = ''
        password = Faker::Internet.password(min_length: 8, max_length: 20)
        user = User.new(email: email, password: password)
        user.valid?
        expect(user.errors.messages[:email]).to include 'を入力してください'
      end
    end

    context '無効なメールアドレスを与えた場合' do
      it 'エラーが発生すること' do
        email = Faker::Internet.email
        password = Faker::Internet.password(min_length: 8, max_length: 20)
        user = User.new(email: email, password: password)
        user.valid?
        expect(user.errors.messages[:email]).to include 'は不正な値です'
      end
    end

    context 'すでに存在するメールを与えた場合' do
      it 'エラーが発生すること' do
        email = Faker::Internet.email
        password = Faker::Internet.password(min_length: 8, max_length: 20)
        old_user = User.create!(email: email, password: password)
        new_user = User.new(email: email, password: password)
        new_user.valid?
        expect(new_user.errors.messages[:email]).to include 'はすでに存在します'
      end
    end

    ### パスワード

    context 'パスワードを与えなかった場合' do
      it 'エラーが発生すること' do
        email = Faker::Internet.email
        password = ''
        user = User.new(email: email, password: password)
        user.valid?
        expect(user.errors.messages[:password_digest]).to include 'を入力してください'
      end
    end

    context 'パスワードで8文字未満の値を与えた場合' do
      it 'エラーが発生すること' do
        email = Faker::Internet.email
        password = Faker::Internet.password(min_length: 4, max_length: 7)
        user = User.new(email: email, password: password)
        user.valid?
        expect(user.errors.messages[:password_digest]).to include 'は8文字以上で入力してください'
      end
    end
  end
end

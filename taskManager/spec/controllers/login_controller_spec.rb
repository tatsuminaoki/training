require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }

  describe "メールアドレスとパスワードが正しい場合" do
    it "一覧画面にリダイレクトされる" do
      post :create, params: {user: {mail: user.mail, password: user.password }}
      expect(response).to redirect_to '/list'
    end
  end

  describe "メールアドレスが空の場合、ログイン画面にリダイレクトされる" do
    it "パスワード画面に戻る" do
      post :create, params: {user: {mail: nil, password: user.password }}
      expect(response).to redirect_to '/login'
    end
  end

  describe "パスワードが空の場合、ログイン画面にリダイレクトされる" do
    it "パスワード画面に戻る" do
      post :create, params: {user: {mail: user.mail, password: nil }}
      expect(response).to redirect_to '/login'
    end
  end

  describe "メールアドレスが存在しない場合、ログイン画面にリダイレクトされる" do
    it "パスワード画面に戻る" do
      post :create, params: {user: {mail: 'mismatch@fablic.co.jp', password: user.password }}
      expect(response).to redirect_to '/login'
    end
  end

  describe "パスワードが間違っていた場合、ログイン画面にリダイレクトされる" do
    it "パスワード画面に戻る" do
      post :create, params: {user: {mail: user.mail, password: 'mismatchpass' }}
      expect(response).to redirect_to '/login'
    end
  end
end

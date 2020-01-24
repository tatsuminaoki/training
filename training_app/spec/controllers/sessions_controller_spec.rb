# frozen_string_literal: true

require 'rails_helper'

describe SessionsController do
  describe 'GET #new' do
    let(:user1) { create(:user) }

    it '正しいユーザー名とパスワードだとログインを行うことができる' do
      session_params = {
        name: user1.name,
        password: 'password',
      }

      post :create, params: { session: session_params }

      expect(response).to redirect_to(tasks_path)
    end

    it '違うパスワードだとログイン画面に戻る' do
      session_params = {
        name: user1.name,
        password: 'password!!',
      }

      post :create, params: { session: session_params }

      expect(response).to redirect_to(sign_in_path)
    end
  end

  describe 'DELETE #destory' do
    let(:user) { create(:user) }

    it '違うパスワードだとログイン画面に戻る' do
      session[:user_id] = user.id
      session[:hoge] = 'foo'

      delete :destroy

      expect(session).to be_empty
      expect(response).to redirect_to(sign_in_path)
    end
  end
end

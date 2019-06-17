# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    it 'returns http success' do
      get :new, params: {}

      expect(response).to be_successful
      expect(response).to render_template('sessions/new')
    end

    context 'すでにログインしている状態で' do
      let(:user) { create(:user) }

      before do
        user_login(user: user)
      end

      it 'root_path にリダイレクトされること' do
        get :new, params: {}

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:user_credential) { user.create_user_credential(password: 'password') }
    let(:params) do
      { session: { email: user.email, password: user_credential.password } }
    end

    it 'ログインできること' do
      post :create, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
      expect(session[:current_user_id]).to eq(user.id)
    end

    context '間違ったパスワードで' do
      before do
        params[:session][:password] = 'hogefuga'
      end

      it 'ログインできないこと' do
        post :create, params: params

        expect(response).to be_successful
        expect(response).to render_template('sessions/new')
      end
    end

    context 'パスワード未設定の状態で' do
      before do
        user_credential.destroy!
      end

      it 'ログインできないこと' do
        post :create, params: params

        expect(response).to be_successful
        expect(response).to render_template('sessions/new')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    before do
      user_login(user: user)
    end

    it 'deletes login session' do
      delete :destroy, params: { id: user.id }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_session_path)
      expect(session[:current_user_id]).to be_nil
    end
  end
end

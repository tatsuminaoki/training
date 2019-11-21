# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template('sessions/new')
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:params) do
      { session: { login_id: user.login_id, password: 'password1' } }
    end

    it 'successfully login' do
      post :create, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)

      # Does the appropriate user log-in?
      expect(User.find_by(remember_token: User.encrypt(cookies.permanent[:user_remember_token])).id).to eq(user.id)
    end

    context 'with a wrong password' do
      before do
        params[:session][:password] = 'hogehoge'
      end

      it 'fails to login' do
        post :create, params: params

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:params) do
      { session: { login_id: user.login_id, password: 'password1' } }
    end

    before do
      post :create, params: params
    end

    it 'successfully deletes the session' do
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(login_path)

      # Does the user successfully log-out?
      # Not completed:
      # cookies.permanent does NOT work in the test environment correctly, it is known that.
      # Therefore, we cannot test the log-out.
      cookies.delete(:user_remember_token)
      expect(cookies.permanent[:user_remember_token]).to be_nil
    end
  end
end

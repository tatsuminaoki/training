# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:task) { create(:task, { user_id: user.id }) }
  let(:params) { { user: { name: 'user2', login_id: 'id2', password: 'password2', password_confirmation: 'password2', role: 'general' } } }
  let(:params2) { { id: user.id, user: { name: 'user2', login_id: 'id2', password: 'password2', password_confirmation: 'password2', role: 'administrator' } } }

  # login
  before do
    remember_token = User.encrypt(cookies[:user_remember_token])
    cookies.permanent[:user_remember_token] = remember_token
    user.update!(remember_token: User.encrypt(remember_token))
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'returns the redirect to the user page' do
      post :create, params: params
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_user_path(User.last))
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #update' do
    it 'returns http success' do
      post :update, params: params2
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_user_path(user))
    end
  end

  describe 'DELETE #destroy' do
    context 'destroy another user' do
      let(:user2) { create(:user2) }
      it 'returns the redirect to the index page' do
        delete :destroy, params: { id: user2.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'destroy oneself' do
      it 'returns the redirect to the user page' do
        delete :destroy, params: { id: user.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_user_path(user))
      end
    end
  end
end

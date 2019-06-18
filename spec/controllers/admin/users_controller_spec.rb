# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { create(:user) }

  before do
    user_login(user: user)
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index, params: {}

      expect(response).to be_successful
      expect(response).to render_template('admin/users/index')
    end
  end

  describe 'POST #create' do
    let(:password) { 'a' * 6 }
    let(:params) do
      {
        user: {
          name: 'name',
          email: 'hoge@test.com',
          email_confirmation: 'hoge@test.com',
          user_credential_attributes: {
            password: password,
            password_confirmation: password,
          },
        },
      }
    end

    it 'ユーザー作成できること' do
      post :create, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_users_path)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: user.to_param }

      expect(response).to be_successful
      expect(response).to render_template('admin/users/show')
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: user.to_param }

      expect(response).to be_successful
      expect(response).to render_template('admin/users/edit')
    end
  end

  describe 'PATCH #update' do
    let(:user_1) {
      create(:user,
             name: 'user1',
             email: 'user1@test.com',
             email_confirmation: 'user1@test.com',
            )
    }
    let(:user_credential_1) { user_1.create_user_credential(password: 'password') }

    let(:password) { 'a' * 6 }
    let(:params) do
      {
        id: user_1.id,
        user: {
          name: 'user2',
          email: 'user2@test.com',
          email_confirmation: 'user2@test.com',
          user_credential_attributes: {
            id: user_credential_1.id,
            password: password,
            password_confirmation: password,
          },
        },
      }
    end

    it 'updates a new user and returns success' do
      patch :update, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_users_path)
      expect(user_1.reload.name).to eq('user2')
    end
  end

  describe 'DELETE #destroy' do
    let(:user_2) {
      create(:user,
             name: 'user2',
             email: 'user2@test.com',
             email_confirmation: 'user2@test.com',
            )
    }
    let!(:user_credential_2) { user_2.create_user_credential(password: 'password') }
    let!(:task) { create(:task, user: user_2) }

    it 'destroys the requested user' do
      delete :destroy, params: { id: user_2.to_param }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_users_path)
      expect(Task.count).to eq(0)
    end
  end
end

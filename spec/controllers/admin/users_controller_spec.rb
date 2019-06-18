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
end

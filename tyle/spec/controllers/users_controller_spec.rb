# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'returns the redirect to login_path' do
      post :create, params: { user: { name: 'user1', login_id: 'id1', password: 'password1', password_confirmation: 'password1' } }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(login_path)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user) { create(:user) }
  before do
    login(user)
  end
  describe 'GET #new' do
    it 'returns http success' do
      get :new, params: { locale: 'ja' }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #create' do
    it 'returns http success' do
      get :create, params: { locale: 'ja' }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #destroy' do
    it 'returns http success' do
      get :destroy, params: { locale: 'ja' }
      expect(response).to have_http_status(:redirect)
    end
  end
end

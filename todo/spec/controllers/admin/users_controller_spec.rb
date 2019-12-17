# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:administrator) { create(:administrator) }

  describe 'GET #index' do
    it 'returns http success' do
      add_session administrator
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      add_session administrator
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      add_session administrator
      get :edit, params: { id: administrator.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      add_session administrator
      get :show, params: { id: administrator.id }
      expect(response).to have_http_status(:success)
    end
  end
end

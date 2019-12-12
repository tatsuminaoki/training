require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do

  let(:user) { create(:user) }

  describe "GET #index" do
    it "returns http success" do
      add_session user
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      add_session user
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      add_session user
      get :edit, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      add_session user
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
  end
end

require 'rails_helper'

describe UsersController, type: :request do
  let!(:user) { create(:user) }

  describe 'GET #new' do
    it 'ステータスコードが200' do
      get new_user_path
      expect(response.status).to eq 200
    end
  end

  describe 'POST #create' do
    it 'ステータスコードが302(リダイレクト)' do
      post users_url, params: { user: attributes_for(:user) }
      expect(response.status).to eq 302
    end

    it 'ユーザーを保存できる' do
      expect do
        post users_url, params: { user: attributes_for(:user) }
      end.to change(User, :count).by(1)
    end
  end
end

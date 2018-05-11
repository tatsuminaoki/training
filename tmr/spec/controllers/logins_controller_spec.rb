require 'rails_helper'


RSpec.describe LoginsController, type: :controller do

  before(:each) do
    # Common Request Headers
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'ja,en-US;q=0.9,en;q=0.8'
    @user = FactoryBot.create(:user)
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #signup' do
    it 'returns a success response' do
      get :signup, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #login' do
    context 'ログイン成功' do
      it 'タスク一覧ページを表示' do
        post :login, params: {login_id: @user[:login_id], password: @user[:login_id]}, session: valid_session
        expect(response).to redirect_to('/tasks')
      end
    end

    context '管理者ログイン' do
      before do
        @user.update({admin_flag: true})
      end
      it 'ユーザ一覧ページを表示' do
        post :login, params: {login_id: @user[:login_id], password: @user[:login_id]}, session: valid_session
        expect(response).to redirect_to('/admin/users')
      end
    end

    context 'ログイン失敗' do
      it 'ログインページを再表示' do
        post :login, params: {login_id: @user[:login_id], password: 'wrong'}, session: valid_session
        expect(response).to redirect_to('/login')
      end
    end
  end

  describe 'POST #register' do
    context 'ユーザ登録成功' do
      it 'タスク一覧ページを表示' do
        post :register, params: {login_id: @user[:login_id], password: @user[:login_id]}, session: valid_session
        expect(response).to be_successful
      end
    end

    context 'ユーザ登録失敗' do
      it 'ユーザ登録ページを再表示' do
        post :register, params: {login_id: @user[:login_id], password: ''}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #logout' do
    it 'ログアウト成功' do
      get :logout, params: {}, session: valid_session
      expect(response).to redirect_to('/login')
    end
  end

end

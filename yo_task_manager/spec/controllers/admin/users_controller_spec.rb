# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:user) { create(:user, role: 'admin') }
  before do
    login(user)
  end
  describe 'GET #index' do
    before { get :index, params: { locale: 'ja' } }
    it 'has 200 status code' do
      expect(response).to have_http_status(:ok)
    end
    it 'assigns @users' do
      expect(assigns(:users)).to contain_exactly(user)
    end
    it 'renders index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new, params: { locale: 'ja' }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #create' do
    let(:user_params) { { login_id: 'dummy_user1', password: 'dummy1234', display_name: 'dummy_display' } }
    it 'save as new user and redirect_to admin_users_path with flash msg' do
      get :create, params: { user: user_params, locale: 'ja' }
      expect(User.last.login_id).to eq 'dummy_user1'
      expect(User.last.display_name).to eq 'dummy_display'
      expect(response).to redirect_to(admin_users_path)
      expect(flash[:success]).to match [I18n.t('admin.users.create.user_saved')]
    end
  end

  describe 'GET #show' do
    it 'renders show template' do
      get :show, params: { id: user.id, locale: 'ja' }
      expect(response).to render_template('show')
      expect(response).to have_http_status(:ok)
      expect(assigns(:user)).to eq user
    end
  end

  describe 'GET #edit' do
    it 'renders edit template' do
      get :edit, params: { id: user.id, locale: 'ja' }
      expect(response).to render_template('edit')
      expect(response).to have_http_status(:ok)
      expect(assigns(:user)).to eq user
    end
  end

  describe 'GET #update' do
    let(:new_params) { { login_id: 'new_login_id', display_name: 'new_display_name' } }
    it 'update the original user login_id and display_name and redirect_to admin_users_path with flash msg' do
      patch :update, params: { id: user.id, user: new_params, locale: 'ja' }
      updated_user = User.find(user.id)
      expect(updated_user.login_id).to eq 'new_login_id'
      expect(updated_user.display_name).to eq 'new_display_name'
      expect(response).to redirect_to(admin_users_path)
      expect(flash[:success]).to match [I18n.t('admin.users.update.user_updated')]
    end
  end

  describe 'GET #destroy' do
    let!(:old_user) { create(:user) }
    it 'should delete the user and redirect_to admin_users_path with flash msg' do
      get :destroy, params: { id: old_user.id, locale: 'ja' }
      expect { User.find(old_user.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      expect(response).to redirect_to(admin_users_path)
      expect(flash[:success]).to match [I18n.t('admin.users.destroy.user_deleted')]
    end
  end
end

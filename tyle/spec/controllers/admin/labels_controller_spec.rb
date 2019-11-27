# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::LabelsController, type: :controller do
  render_views

  let(:admin_user) { create(:admin_user) }
  let!(:label) { create(:label) }

  # login
  before do
    remember_token = User.encrypt(cookies[:user_remember_token])
    cookies.permanent[:user_remember_token] = remember_token
    admin_user.update!(remember_token: User.encrypt(remember_token))
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template('admin/labels/index')
      expect(response.body).to have_content('ラベルリスト')
      expect(response.body).to have_content('label1')
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template('admin/labels/new')
      expect(response.body).to have_content('追加するラベルの詳細を入力してください')
    end
  end

  describe 'POST #create' do
    context 'when user sends the correct parameters' do
      it 'returns the redirect to the label page' do
        post :create, params: { label: { name: 'label2' } }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_label_path(Label.last))

        get :show, params: { id: Label.last.id }
        expect(response).to have_http_status(:success)
        expect(response).to render_template('admin/labels/show')
        expect(response.body).to have_content('ラベルの詳細')
        expect(response.body).to have_content('label2')
      end
    end

    context 'when user sends parameters with empty name' do
      it 'returns http success' do
        post :create, params: { label: { name: '' } }
        expect(response).to have_http_status(:success)
        expect(response).to render_template('admin/labels/new')
      end
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: label.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('admin/labels/show')
      expect(response.body).to have_content('ラベルの詳細')
      expect(response.body).to have_content('label1')
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: label.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template('admin/labels/edit')
      expect(response.body).to have_content('編集するラベルの詳細を入力してください')
    end
  end

  describe 'POST #update' do
    context 'when user sends the correct parameters' do
      it 'returns the redirect to the label page' do
        post :update, params: { id: label.id, label: { name: 'label2' } }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_label_path(label))

        get :show, params: { id: label.id }
        expect(response).to have_http_status(:success)
        expect(response).to render_template('admin/labels/show')
        expect(response.body).to have_content('ラベルの詳細')
        expect(response.body).to have_content('label2')
      end
    end

    context 'when user sends parameters with empty name' do
      it 'returns http success' do
        post :update, params: { id: label.id, label: { name: '' } }
        expect(response).to have_http_status(:success)
        expect(response).to render_template('admin/labels/edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'returns the redirect to the index page' do
      delete :destroy, params: { id: label.id }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_labels_path)
    end
  end
end

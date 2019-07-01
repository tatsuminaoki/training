# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelsController, type: :controller do
  let(:user) { create(:user) }
  let(:label) { create(:label) }

  before do
    user_login(user: user)
  end

  shared_context 'without_permission' do
    before do
      create(:user,
             email: 'test2@example.com',
             email_confirmation: 'test2@example.com',
            )
      user.role_general!
    end
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index, params: {}

      expect(response).to be_successful
      expect(response).to render_template('labels/index')
    end

    context 'without user permission' do
      include_context 'without_permission'

      it 'redirects to root_path page' do
        get :index, params: {}

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new

      expect(response).to be_successful
      expect(response).to render_template('labels/new')
    end

    context 'without user permission' do
      include_context 'without_permission'

      it 'redirects to root_path page' do
        get :new

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    let(:params) do
      {
        label: {
          name: 'label name',
        },
      }
    end

    it 'creates a new label and returns success' do
      post :create, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(label_path(assigns(:label).id))
    end

    context 'without user permission' do
      include_context 'without_permission'

      it 'redirects to root_path page' do
        post :create, params: params

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #show' do
    # let(:label) { create(:label) }

    it 'returns a success response' do
      get :show, params: { id: label.to_param }

      expect(response).to be_successful
      expect(response).to render_template('labels/show')
    end

    context 'without user permission' do
      include_context 'without_permission'

      it 'redirects to root_path page' do
        get :show, params: { id: label.to_param }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: label.to_param }

      expect(response).to be_successful
      expect(response).to render_template('labels/edit')
    end

    context 'without user permission' do
      include_context 'without_permission'

      it 'redirects to root_path page' do
        get :edit, params: { id: label.to_param }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:params) do
      {
        id: label.id,
        label: {
          name: 'nameUpdate',
        },
      }
    end

    it 'updates a new label and returns success' do
      patch :update, params: params

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(label_path(assigns(:label).id))
    end

    context 'without user permission' do
      include_context 'without_permission'

      it 'redirects to root_path page' do
        patch :update, params: params

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested label' do
      delete :destroy, params: { id: label.to_param }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(labels_path)
    end

    context 'without user permission' do
      include_context 'without_permission'

      it 'redirects to root_path page' do
        delete :destroy, params: { id: label.to_param }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end

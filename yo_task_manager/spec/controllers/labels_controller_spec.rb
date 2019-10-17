# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:label) { create(:label, name: '初期ラベル') }
  before do
    login(user)
  end
  context '#index' do
    before { get :index, params: { locale: 'ja' } }
    it 'has 200 status code' do
      expect(response).to have_http_status(:ok)
    end
    it 'assigns @labels' do
      expect(assigns(:labels)).to match_array [label]
    end
    it 'renders index template' do
      expect(response).to render_template('index')
    end
  end

  context '#new' do
    it 'renders new template' do
      get :new, params: { locale: 'ja' }
      expect(response).to render_template('new')
    end
  end

  context '#create' do
    let(:label_params) { { name: 'ラベル名' } }
    it 'save as new label and redirect_to labels_path with flash msg' do
      post :create, params: { label: label_params, locale: 'ja' }
      expect(Label.last.name).to eq 'ラベル名'
      expect(response).to redirect_to(labels_path)
      expect(flash[:success]).to match [I18n.t('labels.create.label_saved')]
    end
  end

  context '#edit' do
    it 'renders edit template' do
      get :edit, params: { id: label, locale: 'ja' }
      expect(response).to render_template('edit')
      expect(response).to have_http_status(:ok)
      expect(assigns(:label)).to eq label
    end
  end

  context '#update' do
    let(:new_params) { { name: '新しいラベル名' } }
    it 'update the original label name and redirect_to labels_path with flash msg' do
      patch :update, params: { id: label, label: new_params, locale: 'ja' }
      updated_label = Label.find(label.id)
      expect(updated_label.name).to eq '新しいラベル名'
      expect(response).to redirect_to(labels_path)
      expect(flash[:success]).to match [I18n.t('labels.update.label_updated')]
    end
  end

  context '#destroy' do
    it 'should delete the label and redirect_to labels_path with flash msg' do
      delete :destroy, params: { id: label.id, locale: 'ja' }
      expect { Label.find(label.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      expect(response).to redirect_to(labels_path)
      expect(flash[:success]).to match [I18n.t('labels.destroy.label_deleted')]
    end
  end
end

require 'rails_helper'

RSpec.describe LabelsController, type: :controller do
  describe 'ログインしていない場合' do
    subject { response }

    #params を検証する前にログインを要求するのでダミーの値を指定する
    let(:params) { { id: 'dummy' } }

    describe 'GET #index' do
      before { get :index }
      it { is_expected.to require_login }
    end

    describe 'GET #show' do
      before { get :show, params: params }
      it { is_expected.to require_login }
    end

    describe 'GET #new' do
      before { get :new }
      it { is_expected.to require_login }
    end

    describe 'GET #edit' do
      before { get :edit, params: params }
      it { is_expected.to require_login }
    end

    describe 'POST #create' do
      before { post :create, params: params }
      it { is_expected.to require_login }
    end

    describe 'POST #update' do
      before { post :update, params: params }
      it { is_expected.to require_login }
    end

    describe 'DELETE #destroy' do

      before { delete :destroy, params: params }
      it { is_expected.to require_login }
    end
  end

  describe 'ログインしている場合' do
    before do
      set_user_session
    end

    describe 'GET #index' do
      let!(:label) { FactoryBot.create(:label) }

      it '@labels にラベル情報を持っている' do
        get :index
        expect(assigns(:labels)[0]).to eq label
      end

      it 'index テンプレートを表示する' do
        get :index
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      let(:label) { FactoryBot.create(:label) }
      let(:params) { { id: label.id } }

      it '@label にラベル情報を持っている' do
        get :show, params: params
        expect(assigns(:label)).to eq label
      end

      it 'show テンプレートを表示する' do
        get :show, params: params
        expect(response).to render_template :show
      end
    end

    describe 'GET #edit' do
      let(:label) { FactoryBot.create(:label) }
      let(:params) { { id: label.id } }

      it '@label にラベル情報を持っている' do
        get :edit, params: params
        expect(assigns(:label)).to eq label
      end

      it 'edit テンプレートを表示する' do
        get :edit, params: params
        expect(response).to render_template :edit
      end
    end

    describe 'GET #new' do
      it 'new テンプレートを表示する' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'データが正しい場合' do
        let(:params) { { label: FactoryBot.attributes_for(:label) } }

        it 'ラベルが新たに作成される' do
          expect{
            post :create, params: params
          }.to change(Label, :count).by(1)
        end
      end

      context 'データが不正な場合' do
        let(:params) { { label: FactoryBot.attributes_for(:label, name: '') } }

        it 'ラベルは作成されない' do
          expect{
            post :create, params: params
          }.not_to change(Label, :count)
        end

        it 'newテンプレートを表示する' do
          get :create, params: params
          expect(response).to render_template :new
        end
      end

      context 'データが重複する場合' do
        let!(:label) { FactoryBot.create(:label, name: 'hoge') }
        let(:params) { { label: FactoryBot.attributes_for(:label, name: 'hoge') } }

        it 'ラベルは作成されない' do
          expect{
            post :create, params: params
          }.not_to change(Label, :count)
        end

        it 'newテンプレートを表示する' do
          get :create, params: params
          expect(response).to render_template :new
        end
      end
    end

    describe 'POST #update' do
      let(:label) { FactoryBot.create(:label) }
      let(:params) { { label: FactoryBot.attributes_for(:label, name: name), id: label.id } }

      context 'データが正しい場合' do
        let(:name) {'hoge'}

        it 'ラベルが更新される' do
          expect(Label.find(label.id)).to eq label
          patch :update, params: params
          expect(Label.find(label.id).name).to eq name
        end
      end

      context 'データが不正な場合' do
        let(:name) {''}

        it 'ラベルは更新されない' do
          expect(Label.find(label.id)).to eq label
          patch :update, params: params
          expect(Label.find(label.id).name).not_to eq name
        end

        it 'editテンプレートを表示する' do
          put :update, params: params
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:label) { FactoryBot.create(:label) }
      let(:params) { {id: label.id} }

      it 'ラベルを削除する' do
        expect(Label.find(label.id)).to eq label
        delete :destroy, params: params
        expect{ Label.find(label.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end


require 'rails_helper'

RSpec.describe TasksController, type: :controller do
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
      context 'ソートしない場合' do
        let!(:task) { FactoryBot.create(:task) }

        it '@tasks にタスク情報を持っている' do
          get :index
          expect(assigns(:tasks)[0]).to eq task
        end

        it 'index テンプレートを表示する' do
          get :index
          expect(response).to render_template :index
        end
      end

      context '終了期限でソートをする場合' do
        let!(:task_1) { FactoryBot.create(:task, end_date: '2017-01-01') }
        let!(:task_2) { FactoryBot.create(:task, end_date: '2017-01-02') }

        context '昇順の場合' do
          let(:params) { {order: 'end_date_asc'} }

          it '@tasks にソートされた情報を持っている' do
            get :index, params: params
            expect(assigns(:tasks)[0]).to eq task_1
            expect(assigns(:tasks)[1]).to eq task_2
          end
        end

        context '降順の場合' do
          let(:params) { {order: 'end_date_desc'} }

          it '@tasks にソートされた情報を持っている' do
            get :index, params: params
            expect(assigns(:tasks)[0]).to eq task_2
            expect(assigns(:tasks)[1]).to eq task_1
          end
        end
      end
    end

    describe 'GET #show' do
      let(:task) { FactoryBot.create(:task) }
      let(:params) { {id: task.id} }

      it '@task にタスク情報を持っている' do
        get :show, params: params
        expect(assigns(:task)).to eq task
      end

      it 'show テンプレートを表示する' do
        get :show, params: params
        expect(response).to render_template :show
      end
    end

    describe 'GET #edit' do
      let(:task) { FactoryBot.create(:task) }
      let(:params) { {id: task.id} }

      it '@task にタスク情報を持っている' do
        get :edit, params: params
        expect(assigns(:task)).to eq task
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
        let(:user) { FactoryBot.create(:user) }
        let(:params) { {task: FactoryBot.attributes_for(:task, user_id: user.id)} }

        it 'タスクが新たに作成される' do
          expect{
            post :create, params: params
          }.to change(Task, :count).by(1)
        end
      end

      context 'データが不正な場合' do
        let(:params) { {task: FactoryBot.attributes_for(:task, name: '')} }

        it 'タスクは作成されない' do
          expect{
            post :create, params: params
          }.not_to change(Task, :count)
        end

        it 'newテンプレートを表示する' do
          get :create, params: params
          expect(response).to render_template :new
        end
      end
    end

    describe 'POST #update' do
      let(:task) { FactoryBot.create(:task) }
      let(:params) { {task: FactoryBot.attributes_for(:task, name: name), id: task.id } }

      context 'データが正しい場合' do
        let(:name) {'hoge'}

        it 'タスクが更新される' do
          expect(Task.find(task.id)).to eq task
          patch :update, params: params
          expect(Task.find(task.id).name).to eq name
        end
      end

      context 'データが不正な場合' do
        let(:name) {''}

        it 'タスクは更新されない' do
          expect(Task.find(task.id)).to eq task
          patch :update, params: params
          expect(Task.find(task.id).name).not_to eq name
        end

        it 'editテンプレートを表示する' do
          put :update, params: params
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:task) { FactoryBot.create(:task) }
      let(:params) { {id: task.id} }

      it 'タスクを削除する' do
        expect(Task.find(task.id)).to eq task
        delete :destroy, params: params
        expect{ Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end

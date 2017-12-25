require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
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

  describe 'ログインしているが管理者権限がない場合' do
    before do
      set_user_session
    end

    subject { response }

    #params を検証する前にログインを要求するのでダミーの値を指定する
    let(:params) { { id: 'dummy' } }

    describe 'GET #index' do
      before { get :index }
      it { is_expected.to require_admin_role }
    end

    describe 'GET #show' do
      before { get :show, params: params }
      it { is_expected.to require_admin_role }
    end

    describe 'GET #new' do
      before { get :new }
      it { is_expected.to require_admin_role }
    end

    describe 'GET #edit' do
      before { get :edit, params: params }
      it { is_expected.to require_admin_role }
    end

    describe 'POST #create' do
      before { post :create, params: params }
      it { is_expected.to require_admin_role }
    end

    describe 'POST #update' do
      before { post :update, params: params }
      it { is_expected.to require_admin_role }
    end

    describe 'DELETE #destroy' do
      before { delete :destroy, params: params }
      it { is_expected.to require_admin_role }
    end
  end

  describe '管理者権限でログインしている場合' do
    before do
      set_admin_user_session
    end

    describe 'GET #index' do
      let!(:user) { FactoryBot.create(:user) }

      it '@users にユーザー情報を持っている' do
        get :index
        #ログインユーザー情報も表示に含まれるので1を指定
        expect(assigns(:users)[1]).to eq user
      end

      it 'index テンプレートを表示する' do
        get :index
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      let(:user) { FactoryBot.create(:user) }
      let(:params) { { id: user.id } }

      it '@user にユーザー情報を持っている' do
        get :show, params: params
        expect(assigns(:user)).to eq user
      end

      it 'show テンプレートを表示する' do
        get :show, params: params
        expect(response).to render_template :show
      end

    end

    describe 'GET #edit' do
      let(:user) { FactoryBot.create(:user) }
      let(:params) { { id: user.id } }

      it '@user にユーザー情報を持っている' do
        get :edit, params: params
        expect(assigns(:user)).to eq user
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
        let(:params) { { user: FactoryBot.attributes_for(:user) } }

        it 'userが新たに作成される' do
          expect{
            post :create, params: params
          }.to change(User, :count).by(1)
        end
      end

      context 'データが不正な場合' do
        let(:params) { { user: FactoryBot.attributes_for(:user, name: '') } }

        it 'userは作成されない' do
          expect{
            post :create, params: params
          }.not_to change(User, :count)
        end

        it 'newテンプレートを表示する' do
          get :create, params: params
          expect(response).to render_template :new
        end
      end
    end

    describe 'POST #update' do
      let(:user) { FactoryBot.create(:user) }
      let(:params) { { user: FactoryBot.attributes_for(:user, name: name, email: email, password: password), id: user.id } }

      context 'データが正しい場合' do
        let(:name) { 'hoge' }
        let(:email) { 'hoge@fuga.com' }

        context 'パスワードを更新する場合' do
          let(:password) { 'abcdefghijk' }

          it 'userが更新される' do
            expect(User.find(user.id)).to eq user
            patch :update, params: params
            expect(User.find(user.id).name).to eq name
            expect(User.find(user.id).email).to eq email
            expect(User.find(user.id).password_digest).not_to eq user.password_digest
          end
        end

        context 'パスワードを更新しない場合' do
          let(:password) { '' }

          it 'userが更新される' do
            expect(User.find(user.id)).to eq user
            patch :update, params: params
            expect(User.find(user.id).name).to eq name
            expect(User.find(user.id).email).to eq email
            expect(User.find(user.id).password_digest).to eq user.password_digest
          end
        end
      end

      context 'データが不正な場合' do
        context 'パスワード以外が間違っている場合' do
          let(:name) { '' }
          let(:email) { '' }
          let(:password) { 'abcdefghijk' }

          it 'userは更新されない' do
            expect(User.find(user.id)).to eq user
            patch :update, params: params
            expect(User.find(user.id).name).not_to eq name
            expect(User.find(user.id).name).not_to eq email
            expect(User.find(user.id).password_digest).to eq user.password_digest
          end

          it 'editテンプレートを表示する' do
            put :update, params: params
            expect(response).to render_template :edit
          end
        end

        context 'パスワードのみが間違っている場合' do
          let(:name) { 'test_name' }
          let(:email) { 'test@test.co.jp' }
          let(:password) { '###' }

          it 'userは更新されない' do
            expect(User.find(user.id)).to eq user
            patch :update, params: params
            expect(User.find(user.id).name).not_to eq name
            expect(User.find(user.id).name).not_to eq email
            expect(User.find(user.id).password_digest).to eq user.password_digest
          end

          it 'editテンプレートを表示する' do
            put :update, params: params
            expect(response).to render_template :edit
          end
        end
      end

      context '管理ユーザーの情報変更を行う場合' do
        let(:params) { { user: FactoryBot.attributes_for(:user, role: role), id: get_user_session } }
        let(:role) { User.roles[:normal] }

        context '管理ユーザーが１名だけの場合' do
          it 'ユーザー権限を変更できない' do
            expect(User.find(get_user_session).admin?).to be true
            patch :update, params: params
            expect(User.find(get_user_session).admin?).not_to be false
          end
        end

        context '管理ユーザーが１名以上の場合' do
          let!(:user) { FactoryBot.create(:user, role: User.roles[:admin]) }

          it 'ユーザー権限を変更できる' do
            expect(User.find(get_user_session).admin?).to be true
            patch :update, params: params
            expect(User.find(get_user_session).admin?).to be false
          end
        end
      end
    end

    describe 'DELETE #destroy' do
      context '通常ユーザーの場合' do
        let(:user) { FactoryBot.create(:user) }
        let(:params) { { id: user.id } }
        let!(:task) { FactoryBot.create(:task, user_id: user.id) }

        it 'userを削除する' do
          expect(User.find(user.id)).to eq user
          delete :destroy, params: params
          expect{ User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'userが作成したタスクも削除される' do
          expect(Task.find(task.id)).to eq task
          delete :destroy, params: params
          expect{ Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context '管理ユーザーの場合' do
        let(:user) { User.find(get_user_session) }
        let(:params) { { id: user.id } }

        context '管理ユーザーが１名だけの場合' do
          it '管理ユーザーを削除できない' do
            expect(User.find(user.id)).to eq user
            delete :destroy, params: params
            expect(User.find(user.id)).to eq user
          end
        end

        context '管理ユーザーが１名以上の場合' do
          before { FactoryBot.create(:user, role: User.roles[:admin]) }

          it '管理ユーザーを削除できる' do
            expect(User.find(user.id)).to eq user
            delete :destroy, params: params
            expect{ User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end

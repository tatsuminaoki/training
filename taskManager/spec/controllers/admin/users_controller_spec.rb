require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user1) { FactoryBot.create(:user, password: 'hogehoge1', role: :admin) }
  let(:user2) { FactoryBot.create(:user, password: 'hogehoge2', role: :admin) }
  let!(:task1) { FactoryBot.create_list(:task, 10, user: user1) }
  let!(:task2) { FactoryBot.create_list(:task, 10, user: user2) }

  describe "セッションデータがない場合" do
    let(:user_params) { FactoryBot.attributes_for(:user) }
    subject do
      expect(response).to redirect_to '/login'
    end
    it "ユーザ一覧" do
      get :index
    end
    it "ユーザ一のタスク一覧" do
      get :show, params: { id: user1.id }
    end
    it "ユーザ新規フォーム" do
      post :new
    end
    it "ユーザ新規登録" do
      post :create
    end
    it "ユーザ変更画面" do
      post :edit, params: { id: user1.id }
    end
    it "ユーザ変更" do
      patch :update, params: { id: user1.id, user: user_params }
    end
  end
  describe "セッションデータがある" do
    before do
      controller.send(:make_session, user: user1)
    end
    describe "ユーザ一覧画面" do
      subject do
        expect(response).to have_http_status '200'
      end
      it "正常にレスポンス(200)を返すこと" do
        get :index
      end
      it "正常にレスポンス(200)を返すこと" do
        get :show, params: { id: user1.id }
      end
      it "タスク名の検索ができる" do
        get :show, params: { id: user1.id, task_name: "task" }
      end
      it "ステータスの検索ができる" do
        get :show, params: { id: user1.id, status: :waiting }
      end
    end
    describe "ユーザ登録画面" do
      let(:user_params) { FactoryBot.attributes_for(:user) }
      it "ユーザが追加できること" do
        expect do
          post :create, params: { user: user_params }
        end.to change(User, :count).by(1)
      end
      it "ユーザ名が空の場合、追加できないこと" do
        user_params[:user_name] = nil
        expect do
          post :create, params: { user: user_params }
        end.to_not change(User, :count)
      end
      it "メールが空の場合、追加できないこと" do
        user_params[:mail] = nil
        expect do
          post :create, params: { user: user_params }
        end.to_not change(User, :count)
      end
      it "パスワードが空の場合、追加できないこと" do
        user_params[:password] = nil
        expect do
          post :create, params: { user: user_params }
        end.to_not change(User, :count)
      end
      it "確認パスワードが空の場合、追加できないこと" do
        user_params[:password_confirmation] = nil
        expect do
          post :create, params: { user: user_params }
        end.to_not change(User, :count)
      end
      it "確認パスワードがパスワードと一致しない場合、追加できないこと" do
        user_params[:password_confirmation] = 'hogehoge'
        expect do
          post :create, params: { user: user_params }
        end.to_not change(User, :count)
      end
    end
    describe "ユーザ登録削除処理" do
      it "存在するユーザIDのユーザ削除ができること" do
        expect do
          delete :destroy, params: { id: user2.id }
        end.to change(User, :count).by(-1)
      end
      it "存在しないユーザIDの削除はできない" do
        expect do
          delete :destroy, params: { id: user1.id + 1000 }
        end.not_to change(User, :count)
      end
    end
    describe "ユーザ変更処理" do
      let(:user_params) { FactoryBot.attributes_for(:user, role: :admin) }

      it "ユーザ名変更ができること" do
        user_params[:user_name] = 'new name'
        patch :update, params: { id: user1.id, user: user_params }
        expect(user1.reload.user_name).to eq user_params[:user_name]
      end
      it "メール変更ができること" do
        user_params[:mail] = 'test@mail.com'
        patch :update, params: { id: user1.id, user: user_params }
        expect(user1.reload.mail).to eq user_params[:mail]
      end
      it "メール変更ができること" do
        user_params[:mail] = 'test@mail.com'
        patch :update, params: { id: user1.id, user: user_params }
        expect(user1.reload.mail).to eq user_params[:mail]
      end
      it "存在しないタスクIDのタスク変更はできないこと" do
        expect do
          patch :update, params: { id: user1.id + 1000, task: user_params }
        end.not_to change(User, :count)
      end
      it "権限の変更ができること" do
        user_params[:role] = 'normal'
        patch :update, params: { id: user2.id, user: user_params }
        expect(user2.reload.role).to eq user_params[:role]
      end
      it "自分自身の権限をadmin->normalに変更できないこと" do
        user_params[:role] = 'normal'
        patch :update, params: { id: user1.id, user: user_params }
        expect(user2.reload.role).not_to eq user_params[:role]
      end
    end
  end
end

require 'rails_helper'

RSpec.describe ListController, type: :controller do
  # TODO user_idを1固定にしているので、セッション管理するようになったら変更すること
  let(:user1) { FactoryBot.create(:user, password: 'hogehoge1', role: :admin) }
  let(:user2) { FactoryBot.create(:user, password: 'hogehoge2', role: :admin) }
  let!(:task1) { FactoryBot.create(:task, user_id: user1.id, status: :waiting) }
  let!(:task2) { FactoryBot.create(:task, user_id: user1.id, status: :waiting) }
  let!(:task3) { FactoryBot.create(:task, user_id: user2.id, status: :completed) }

  describe "セッションデータがない場合" do
    let(:task_params) { FactoryBot.attributes_for(:task) }
    it "一覧" do
      get :index
      expect(response).to redirect_to '/login'
    end
    it "タスク新規フォーム" do
      post :new
      expect(response).to redirect_to '/login'
    end
    it "タスク新規登録" do
      post :create
      expect(response).to redirect_to '/login'
    end
    it "タスク変更画面" do
      post :edit, params: { id: task1.id }
      expect(response).to redirect_to '/login'
    end
    it "タスク変更" do
      patch :update, params: { id: task1.id, task: task_params }
      expect(response).to redirect_to '/login'
    end
  end

  describe "セッションデータがある" do
    before do
      controller.send(:make_session, user: user1)
    end
    describe "タスク一覧画面" do
      it "正常にレスポンス(200)を返すこと" do
        get :index
        expect(response).to have_http_status "200"
      end
      # TODO: まだ実装してない
      pending "全体的に値の範囲テストを指定ない"
      it "タスク名の検索ができる" do
        get :index, params: { task_name: "task" }
        expect(response).to have_http_status "200"
      end
      it "ステータスの検索ができる" do
        get :index, params: { status: :waiting }
        expect(response).to have_http_status "200"
      end
    end

    describe "タスク登録画面" do
      let(:task_params) { FactoryBot.attributes_for(:task) }
      it "タスクが追加できること" do
        expect do
          post :create, params: { task: task_params }
        end.to change(user1.task, :count).by(1)
      end
      it "タスク名が空の場合、追加できないこと" do
        task_params[:task_name] = nil
        expect do
          post :create, params: { task: task_params }
        end.to_not change(user1.task, :count)
      end
      it "説明が空の場合、追加できないこと" do
        task_params[:description] = nil
        expect do
          post :create, params: { task: task_params }
        end.to_not change(user1.task, :count)
      end
      it "優先度が空の場合、追加できないこと" do
        task_params[:priority] = nil
        expect do
          post :create, params: { task: task_params }
        end.to_not change(user1.task, :count)
      end
      it "ステータスが空の場合、追加できないこと" do
        task_params[:status] = nil
        expect do
          post :create, params: { task: task_params }
        end.to_not change(user1.task, :count)
      end
      # TODO: まだ実装していないので実装すること
      it "未認証のユーザでアクセスするとログイン画面にリダイレクトされること"
    end

    describe "タスク登録削除処理" do
      it "存在するタスクIDのタスク削除ができること" do
        expect do
          delete :destroy, params: { id: task1.id }
        end.to change(user1.task, :count).by(-1)
      end
      it "存在しないタスクIDのタスク削除はエラーになること" do
        expect do
          delete :destroy, params: { id: task1.id + 1000 }
        end.not_to change(user1.task, :count)
      end
      it "異なるユーザIDでタスク削除ができないこと" do
        expect do
          delete :destroy, params: { id: task3.id }
        end.not_to change(user1.task, :count)
      end
    end

    describe "タスク変更処理" do
      it "存在するタスクIDのタスク名変更ができること" do
        task_params = FactoryBot.attributes_for(:task, task_name: "newtask1")
        patch :update, params: { id: task1.id, task: task_params }
        expect(task1.reload.task_name).to eq "newtask1"
      end
      it "存在するタスクIDの説明変更ができること" do
        task_params = FactoryBot.attributes_for(:task, description: "new-description")
        patch :update, params: { id: task1.id, task: task_params }
        expect(task1.reload.description).to eq "new-description"
      end
      it "存在するタスクIDの期限変更ができること" do
        date = Date.today
        task_params = FactoryBot.attributes_for(:task, deadline: date)
        patch :update, params: { id: task1.id, task: task_params }
        expect(task1.reload.deadline).to eq date
      end
      it "存在するタスクIDの優先度変更ができること" do
        date = Date.today
        task_params = FactoryBot.attributes_for(:task, priority: :common)
        patch :update, params: { id: task1.id, task: task_params }
        expect(task1.reload.priority).to eq "common"
      end
      it "存在するタスクIDのステータス変更ができること" do
        date = Date.today
        task_params = FactoryBot.attributes_for(:task, status: :completed)
        patch :update, params: { id: task1.id, task: task_params }
        expect(task1.reload.status).to eq "completed"
      end
      it "存在しないタスクIDのタスク変更はできないこと" do
        task_params = FactoryBot.attributes_for(:task, task_name: "newtask1")
        expect do
          patch :update, params: { id: task1.id + 1000, task: task_params }
        end.not_to change(user1.task, :count)
      end
    end
  end
end

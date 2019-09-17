describe TasksController, type: :request do
  describe 'GET #index' do
    before do
      FactoryBot.create :task1
      FactoryBot.create :task2
    end

    it 'リクエストが成功すること' do
      get tasks_url
      expect(response.status).to eq 200
    end

    it 'タイトルが表示されていること' do
      get tasks_url
      expect(response.body).to include "Task1"
      expect(response.body).to include "Task2"
    end
  end

  describe 'GET #new' do
    it 'リクエストが成功すること' do
      get new_task_url
      expect(response.status).to eq 200
    end
  end

  describe 'POST #create' do
    context '正常なパラメータの場合' do
      it 'リクエストが成功すること' do
        post tasks_url, params: { task: FactoryBot.attributes_for(:task) }
        expect(response.status).to eq 302
      end

      it 'タスクが登録されること' do
        expect do
          post tasks_url, params: { task: FactoryBot.attributes_for(:task) }
        end.to change(Task, :count).by(1)
      end

      it 'TOPにリダイレクトすること' do
        post tasks_url, params: { task: FactoryBot.attributes_for(:task) }
        expect(response).to redirect_to '/'
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post tasks_url, params: { task: FactoryBot.attributes_for(:task, title: nil) }
        expect(response.status).to eq 200
      end

      it 'ユーザーが登録されないこと' do
        expect do
          post tasks_url, params: { task: FactoryBot.attributes_for(:task, title: nil) }
        end.to_not change(Task, :count)
      end

      it 'エラーが表示されること' do
        post tasks_url, params: { task: FactoryBot.attributes_for(:task, title: nil) }
        expect(response.body).to include '登録に失敗しました'
      end
    end
  end

  describe 'GET #edit' do
    let(:task1) { FactoryBot.create :task1 }
  
    it 'リクエストが成功すること' do
      get edit_task_url task1
      expect(response.status).to eq 200
    end
 
    it 'タイトルが表示されていること' do
      get edit_task_url task1
      expect(response.body).to include 'Task1'
    end

    it '説明が表示されていること' do
      get edit_task_url task1
      expect(response.body).to include 'Description1'
    end
  end

  describe 'PUT #update' do
    let(:task1) { FactoryBot.create :task1 }
  
    context '正常なパラメータの場合' do
      it 'リクエストが成功すること' do
        put task_url task1, params: { task: FactoryBot.attributes_for(:task2) }
        expect(response.status).to eq 302
      end

      it 'タイトルが更新されること' do
        expect do
          put task_url task1, params: { task: FactoryBot.attributes_for(:task2) }
        end.to change { Task.find(task1.id).title }.from('Task1').to('Task2')
      end

      it 'リダイレクトすること' do
        put task_url task1, params: { task: FactoryBot.attributes_for(:task2) }
        expect(response).to redirect_to '/'
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        put task_url task1, params: { task: FactoryBot.attributes_for(:task3) }
        expect(response.status).to eq 302
      end

      it 'タイトルが更新しないこと' do
        expect do
          put task_url task1, params: { task: FactoryBot.attributes_for(:task3) }
        end.to_not change(Task.find(task1.id), :title)
      end

      it 'TOPにリダイレクトすること' do
        put task_url task1, params: { task: FactoryBot.attributes_for(:task3) }
        expect(response).to redirect_to '/'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:task1) { FactoryBot.create :task1 }

    it 'リクエストが成功すること' do
      delete task_url task1
      expect(response.status).to eq 302
    end

    it 'タスクが削除されること' do
      expect do
        delete task_url task1
      end.to change(Task, :count).by(-1)
    end

    it 'TOPにリダイレクトすること' do
      delete task_url task1
      expect(response).to redirect_to '/'
    end
  end
end

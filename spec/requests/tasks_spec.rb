require 'rails_helper'

describe TasksController, type: :request do
  let!(:task) { create(:task) }

  describe 'GET #index' do
    it 'ステータスコードが200' do
      get tasks_url
      expect(response.status).to eq 200
    end
  end

  describe 'GET #show' do
    it 'ステータスコードが200' do
      get task_path(task)
      expect(response.status).to eq 200
    end
  end

  describe 'GET #new' do
    it 'ステータスコードが200' do
      get new_task_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET #edit' do
    it 'ステータスコードが200' do
      get edit_task_path(task)
      expect(response.status).to eq 200
    end
  end

  xdescribe 'POST #create' do
    it 'ステータスコードが302(リダイレクト)' do
      post tasks_url, params: { task: attributes_for(:task) }
      expect(response.status).to eq 302
    end

    it 'タスクを保存できる' do
      expect do
        post tasks_url, params: { task: attributes_for(:task) }
      end.to change(Task, :count).by(1)
    end

    it 'showにリダイレクトされる' do
      post tasks_url, params: { task: attributes_for(:task) }
      expect(response).to redirect_to(task_path(Task.last))
    end
  end

  describe 'PATCH #update' do
    let(:task) { create(:task, title: 'old title', detail: 'old detail') }
    let(:update_attributes) { { title: 'new title', detail: 'new detail' } }

    it 'ステータスコードが302(リダイレクト)' do
      put task_url(task), params: { task: update_attributes }
      expect(response.status).to eq 302
    end

    it 'タスクを更新できる' do
      expect do
        put task_url(task), params: { task: update_attributes }
      end.to change { Task.last.title }.from('old title').to('new title')
    end

    it 'showにリダイレクトされる' do
      put task_url(task), params: { task: update_attributes }
      expect(response).to redirect_to(task_path(Task.last))
    end
  end

  describe 'DELETE #destroy' do
    it 'ステータスコードが302(リダイレクト)' do
      delete task_url(task)
      expect(response.status).to eq 302
    end

    it 'タスクを削除できる' do
      expect do
        delete task_url(task)
      end.to change(Task, :count).by(-1)
    end

    it 'indexにリダイレクトされる' do
      delete task_url(task)
      expect(response).to redirect_to(tasks_url)
    end
  end
end

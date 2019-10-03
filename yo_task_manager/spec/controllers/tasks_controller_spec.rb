require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  context '#index' do
    it 'assigns @task' do
      tasks = Task.all.reverse
      get :index
      expect(assigns(:tasks)).to eq(tasks)
    end
    it 'renders index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  context '#new' do
    it 'renders new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  context '#create' do
    let(:task_params) { {title: 'タイトル', body: '長い説明文ですよ！'} }
    it 'save as new task and redirect_to tasks_path with flash msg' do
      post :create, params: { task: task_params }
      expect(Task.last.title).to eq 'タイトル'
      expect(Task.last.body).to eq '長い説明文ですよ！'
      expect(response).to redirect_to(tasks_path)
      expect(flash[:success]).to match 'タスクが保存されました。'
    end
  end

  context '#show' do
    task = Task.create
    it 'renders show template' do
      get :show, params: { id: task }
      expect(response).to render_template('show')
      expect(response).to have_http_status(:ok)
    end
  end

  context '#edit' do
    it 'renders edit template' do
      task = Task.create
      get :edit, params: { id: task }
      expect(response).to render_template('edit')
      expect(response).to have_http_status(:ok)
    end
  end

  context '#update' do
    let(:original_task) { Task.create(title: '古い', body: '古い説明') }
    let(:new_params) { { title: '新しい', body: '新しい説明' } }
    it 'update the original_task title and body and redirect_to tasks_path with flash msg' do
      patch :update, params: { id: original_task.id, task: new_params }
      updated_task = Task.find(original_task.id)
      expect(updated_task.title).to eq '新しい'
      expect(updated_task.body).to eq '新しい説明'
      expect(response).to redirect_to(tasks_path)
      expect(flash[:success]).to match 'タスクが更新されました。'
    end
  end

  context '#destroy' do
    let!(:exist_task) { Task.create(title: '削除されるべきタスク', body: 'このタスクは削除されるべきです。') }
    it 'should delete the task and redirect_to tasks_path with flash msg' do
      delete :destroy, params: { id: exist_task.id }
      expect{Task.find(exist_task.id)}.to raise_exception(ActiveRecord::RecordNotFound)
      expect(response).to redirect_to(tasks_path)
      expect(flash[:success]).to match 'タスクが削除されました。'
    end
  end
end

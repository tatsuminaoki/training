# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user: user, title: '初期タスク', body: '初期説明文') }
  before do
    login(user)
  end
  context '#index' do
    before { get :index, params: { locale: 'ja' } }
    it 'has 200 status code' do
      expect(response).to have_http_status(:ok)
    end
    it 'assigns @task' do
      expect(assigns(:tasks)).to match_array [task]
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
    let(:task_params) { { title: 'タイトル', body: '長い説明文ですよ！' } }
    it 'save as new task and redirect_to tasks_path with flash msg' do
      post :create, params: { task: task_params, locale: 'ja' }
      expect(Task.first.title).to eq 'タイトル'
      expect(Task.first.body).to eq '長い説明文ですよ！'
      expect(response).to redirect_to(tasks_path)
      expect(flash[:success]).to match [I18n.t('tasks.create.task_saved')]
    end
  end

  context '#show' do
    it 'renders show template' do
      get :show, params: { id: task, locale: 'ja' }
      expect(response).to render_template('show')
      expect(response).to have_http_status(:ok)
      expect(assigns(:task)).to eq task
    end
  end

  context '#edit' do
    it 'renders edit template' do
      get :edit, params: { id: task, locale: 'ja' }
      expect(response).to render_template('edit')
      expect(response).to have_http_status(:ok)
      expect(assigns(:task)).to eq task
    end
  end

  context '#update' do
    let(:new_params) { { title: '新しい', body: '新しい説明' } }
    it 'update the original_task title and body and redirect_to tasks_path with flash msg' do
      patch :update, params: { id: task.id, task: new_params, locale: 'ja' }
      updated_task = Task.find(task.id)
      expect(updated_task.title).to eq '新しい'
      expect(updated_task.body).to eq '新しい説明'
      expect(response).to redirect_to(tasks_path)
      expect(flash[:success]).to match [I18n.t('tasks.update.task_updated')]
    end
  end

  context '#destroy' do
    it 'should delete the task and redirect_to tasks_path with flash msg' do
      delete :destroy, params: { id: task.id, locale: 'ja' }
      expect { Task.find(task.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      expect(response).to redirect_to(tasks_path)
      expect(flash[:success]).to match [I18n.t('tasks.destroy.task_deleted')]
    end
  end
end

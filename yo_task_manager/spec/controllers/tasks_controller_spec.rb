# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  context '#index' do
    it 'assigns @task' do
      tasks = Task.all.reverse
      get :index, params: { locale: 'ja' }
      expect(assigns(:tasks)).to eq(tasks)
    end
    it 'renders index template' do
      get :index, params: { locale: 'ja' }
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
      expect(Task.last.title).to eq 'タイトル'
      expect(Task.last.body).to eq '長い説明文ですよ！'
      expect(response).to redirect_to(tasks_path)
      expect(flash[:success]).to match I18n.t('tasks.create.task_saved')
    end
  end

  context '#show' do
    it 'renders show template' do
      task = Task.create
      get :show, params: { id: task, locale: 'ja' }
      expect(response).to render_template('show')
      expect(response).to have_http_status(:ok)
    end
  end

  context '#edit' do
    it 'renders edit template' do
      task = Task.create
      get :edit, params: { id: task, locale: 'ja' }
      expect(response).to render_template('edit')
      expect(response).to have_http_status(:ok)
    end
  end

  context '#update' do
    let(:original_task) { Task.create(title: '古い', body: '古い説明') }
    let(:new_params) { { title: '新しい', body: '新しい説明' } }
    it 'update the original_task title and body and redirect_to tasks_path with flash msg' do
      patch :update, params: { id: original_task.id, task: new_params, locale: 'ja' }
      updated_task = Task.find(original_task.id)
      expect(updated_task.title).to eq '新しい'
      expect(updated_task.body).to eq '新しい説明'
      expect(response).to redirect_to(tasks_path)
      expect(flash[:success]).to match I18n.t('tasks.update.task_updated')
    end
  end

  context '#destroy' do
    let!(:exist_task) { Task.create(title: '削除されるべきタスク', body: 'このタスクは削除されるべきです。') }
    it 'should delete the task and redirect_to tasks_path with flash msg' do
      delete :destroy, params: { id: exist_task.id, locale: 'ja' }
      expect { Task.find(exist_task.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      expect(response).to redirect_to(tasks_path)
      expect(flash[:success]).to match I18n.t('tasks.destroy.task_deleted')
    end
  end
end

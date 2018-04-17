require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  describe 'GET #index' do
    it 'タスク一覧ページを表示する' do
      get :index, params: {}
      expect(response).to be_successful
    end
  end
  describe 'GET #show' do
    it 'タスク１の詳細を表示する' do
      @task = create(:task)
      get :show, params: {id: @task}
      expect(response).to be_successful
    end
  end
  describe 'GET #new' do
    it 'タスク作成ページを表示する' do
      get :new, params: {}
      expect(response).to be_successful
    end
  end
  describe 'GET #edit' do
    it 'タスク１の修正ページを表示する' do
      @task = create(:task)
      get :edit, params: {id: @task}
      expect(response).to be_successful
    end
  end
  describe 'POST #create' do
    it 'タスクを作成する' do
      expect {
        post :create, params: {task: attributes_for(:task)}
      }.to change(Task, :count).by(1)
    end
  end
  describe 'PATCH #update' do
    it 'タスクを修正する' do
      @task = create(:task)
      patch :update, params: {id: @task, task: attributes_for(:newly_titled_task)}
      @task.reload
      expect(@task.title).to eq('Updated Title')
    end
  end
  describe 'DELETE #destroy' do
    it 'タスクを削除する' do
      @task = create(:task)
      expect{
        delete :destroy, params: {id: @task}
      }.to change(Task, :count).by(-1)
    end
  end
end

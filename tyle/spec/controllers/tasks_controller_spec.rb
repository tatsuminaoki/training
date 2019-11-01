# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { User.create(id: 1, name: 'user1', login_id: 'id1', password_digest: 'password1') }
  let(:task) { Task.create(name: 'task1', description: 'this is a task1', user_id: user.id, priority: 0, status: 0, due: '20201231') }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'returns redirect to the created task page' do
      post :create, params: { task: { name: 'task1', description: 'this is a task1', user_id: user.id, priority: 'low', status: 'waiting', due: '20201231' } }
      expect(response).to redirect_to(task_path(Task.last))
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: task.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: task.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    it 'returns redirect to the updated task page' do
      patch :update, params: { id: task.id, task: { name: 'task2', description: 'this is a task2', user_id: user.id, priority: 'medium', status: 'in_progress', due: '20201231' } }
      expect(response).to redirect_to(task_path(task))
    end
  end

  describe 'DELETE #destroy' do
    it 'returns redirect to the index page' do
      delete :destroy, params: { id: task.id }
      expect(response).to redirect_to(tasks_path)
    end
  end
end

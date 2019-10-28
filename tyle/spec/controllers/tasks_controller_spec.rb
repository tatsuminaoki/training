# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { User.create(id: 1, name: 'user1', login_id: 'id1', password_digest: 'password1') }
  let(:task) { Task.create(name: 'task1', description: 'this is a task1', user_id: user.id, priority: 0, status: 0) }

  it 'tests get index' do
    get :index
    expect(response).to be_successful
  end

  it 'tests get new' do
    get :new
    expect(response).to be_successful
  end

  it 'tests post create' do
    post :create, params: { task: { name: 'task1', description: 'this is a task1', user_id: user.id, priority: 'low', status: 'waiting' } }
    expect(response).to redirect_to(task_path(Task.last))
  end

  it 'tests get show' do
    get :show, params: { id: task.id }
    expect(response).to be_successful
  end

  it 'tests get edit' do
    get :edit, params: { id: task.id }
    expect(response).to be_successful
  end

  it 'tests get update' do
    post :update, params: { id: task.id, task: { name: 'task2', description: 'this is a task2', user_id: user.id, priority: 'medium', status: 'in_progress' } }
    expect(response).to redirect_to(task_path(task))
  end

  it 'tests get destroy' do
    get :destroy, params: { id: task.id }
    expect(response).to redirect_to(tasks_path)
  end
end

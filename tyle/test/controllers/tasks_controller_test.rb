# frozen_string_literal: true

require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get tasks_path
    assert_response :success
  end

  test 'should get new' do
    get new_task_path
    assert_response :success
  end

  test 'should get create' do
    @user = User.create!(id: 1, name: 'user1', login_id: 'id1', 'password_digest': 'password1')
    post tasks_path, params: { task: { name: 'task1', description: 'this is a task1', user_id: @user.id, priority: 'low', status: 'waiting' } }
    assert_response :redirect
  end

  test 'should get show' do
    @user = User.create!(id: 1, name: 'user1', login_id: 'id1', 'password_digest': 'password1')
    @task = Task.create!(name: 'task1', description: 'this is a task1', user_id: @user.id, priority: 0, status: 0)
    get task_path(@task)
    assert_response :success
  end

  test 'should get edit' do
    @user = User.create!(id: 1, name: 'user1', login_id: 'id1', 'password_digest': 'password1')
    @task = Task.create!(name: 'task1', description: 'this is a task1', user_id: @user.id, priority: 0, status: 0)
    get edit_task_path(@task)
    assert_response :success
  end

  test 'should get update' do
    @user = User.create!(id: 1, name: 'user1', login_id: 'id1', 'password_digest': 'password1')
    @task = Task.create!(name: 'task1', description: 'this is a task1', user_id: @user.id, priority: 0, status: 0)
    post tasks_path, params: { task: { name: 'task2', description: 'this is a task2', user_id: @user.id, priority: 'medium', status: 'in_progress' } }
    assert_response :redirect
  end

  test 'should get destroy' do
    @user = User.create!(id: 1, name: 'user1', login_id: 'id1', 'password_digest': 'password1')
    @task = Task.create!(name: 'task1', description: 'this is a task1', user_id: @user.id, priority: 0, status: 0)
    delete task_path(@task)
    assert_response :redirect
  end
end

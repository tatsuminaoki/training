# frozen_string_literal: true

require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @task = tasks(:one)
  end

  test 'should get new' do
    get tasks_new_url
    assert_response :success
  end

  test 'should get edit' do
    get edit_task_url(@task)
    assert_response :success
  end

  test 'should get show' do
    get task_url(@task)
    assert_response :success
  end

  test 'should get index' do
    get tasks_url
    assert_response :success
  end
end

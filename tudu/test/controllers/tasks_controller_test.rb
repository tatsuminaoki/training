require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest

  test 'should get index' do
    get root_path
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end
end

require 'test_helper'

class LoginsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get logins_index_url
    assert_response :success
  end

  test "should get login" do
    get logins_login_url
    assert_response :success
  end

  test "should get logout" do
    get logins_logout_url
    assert_response :success
  end

end

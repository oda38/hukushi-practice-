require "test_helper"

class Publics::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get publics_users_index_url
    assert_response :success
  end

  test "should get edit" do
    get publics_users_edit_url
    assert_response :success
  end

  test "should get show" do
    get publics_users_show_url
    assert_response :success
  end
end

require 'test_helper'

class AuthusersControllerTest < ActionController::TestCase
  setup do
    @authuser = authusers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:authusers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create authuser" do
    assert_difference('Authuser.count') do
      post :create, authuser: @authuser.attributes
    end

    assert_redirected_to authuser_path(assigns(:authuser))
  end

  test "should show authuser" do
    get :show, id: @authuser.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @authuser.to_param
    assert_response :success
  end

  test "should update authuser" do
    put :update, id: @authuser.to_param, authuser: @authuser.attributes
    assert_redirected_to authuser_path(assigns(:authuser))
  end

  test "should destroy authuser" do
    assert_difference('Authuser.count', -1) do
      delete :destroy, id: @authuser.to_param
    end

    assert_redirected_to authusers_path
  end
end

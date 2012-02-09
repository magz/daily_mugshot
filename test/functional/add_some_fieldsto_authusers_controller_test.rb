require 'test_helper'

class AddSomeFieldstoAuthusersControllerTest < ActionController::TestCase
  setup do
    @add_some_fieldsto_authuser = add_some_fieldsto_authusers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:add_some_fieldsto_authusers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create add_some_fieldsto_authuser" do
    assert_difference('AddSomeFieldstoAuthuser.count') do
      post :create, add_some_fieldsto_authuser: @add_some_fieldsto_authuser.attributes
    end

    assert_redirected_to add_some_fieldsto_authuser_path(assigns(:add_some_fieldsto_authuser))
  end

  test "should show add_some_fieldsto_authuser" do
    get :show, id: @add_some_fieldsto_authuser.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @add_some_fieldsto_authuser.to_param
    assert_response :success
  end

  test "should update add_some_fieldsto_authuser" do
    put :update, id: @add_some_fieldsto_authuser.to_param, add_some_fieldsto_authuser: @add_some_fieldsto_authuser.attributes
    assert_redirected_to add_some_fieldsto_authuser_path(assigns(:add_some_fieldsto_authuser))
  end

  test "should destroy add_some_fieldsto_authuser" do
    assert_difference('AddSomeFieldstoAuthuser.count', -1) do
      delete :destroy, id: @add_some_fieldsto_authuser.to_param
    end

    assert_redirected_to add_some_fieldsto_authusers_path
  end
end

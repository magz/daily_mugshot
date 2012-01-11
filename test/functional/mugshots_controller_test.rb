require 'test_helper'

class MugshotsControllerTest < ActionController::TestCase
  setup do
    @mugshot = mugshots(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mugshots)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mugshot" do
    assert_difference('Mugshot.count') do
      post :create, mugshot: @mugshot.attributes
    end

    assert_redirected_to mugshot_path(assigns(:mugshot))
  end

  test "should show mugshot" do
    get :show, id: @mugshot.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mugshot.to_param
    assert_response :success
  end

  test "should update mugshot" do
    put :update, id: @mugshot.to_param, mugshot: @mugshot.attributes
    assert_redirected_to mugshot_path(assigns(:mugshot))
  end

  test "should destroy mugshot" do
    assert_difference('Mugshot.count', -1) do
      delete :destroy, id: @mugshot.to_param
    end

    assert_redirected_to mugshots_path
  end
end

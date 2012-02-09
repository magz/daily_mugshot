require 'test_helper'

class TwitterConnectsControllerTest < ActionController::TestCase
  setup do
    @twitter_connect = twitter_connects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:twitter_connects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create twitter_connect" do
    assert_difference('TwitterConnect.count') do
      post :create, twitter_connect: @twitter_connect.attributes
    end

    assert_redirected_to twitter_connect_path(assigns(:twitter_connect))
  end

  test "should show twitter_connect" do
    get :show, id: @twitter_connect.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @twitter_connect.to_param
    assert_response :success
  end

  test "should update twitter_connect" do
    put :update, id: @twitter_connect.to_param, twitter_connect: @twitter_connect.attributes
    assert_redirected_to twitter_connect_path(assigns(:twitter_connect))
  end

  test "should destroy twitter_connect" do
    assert_difference('TwitterConnect.count', -1) do
      delete :destroy, id: @twitter_connect.to_param
    end

    assert_redirected_to twitter_connects_path
  end
end

require 'test_helper'

class LandmarksControllerTest < ActionController::TestCase
  setup do
    @landmark = landmarks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:landmarks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create landmark" do
    assert_difference('Landmark.count') do
      post :create, landmark: @landmark.attributes
    end

    assert_redirected_to landmark_path(assigns(:landmark))
  end

  test "should show landmark" do
    get :show, id: @landmark.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @landmark.to_param
    assert_response :success
  end

  test "should update landmark" do
    put :update, id: @landmark.to_param, landmark: @landmark.attributes
    assert_redirected_to landmark_path(assigns(:landmark))
  end

  test "should destroy landmark" do
    assert_difference('Landmark.count', -1) do
      delete :destroy, id: @landmark.to_param
    end

    assert_redirected_to landmarks_path
  end
end

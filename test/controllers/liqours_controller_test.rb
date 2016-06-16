require 'test_helper'

class LiqoursControllerTest < ActionController::TestCase
  setup do
    @liqour = liqours(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:liqours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create liqour" do
    assert_difference('Liqour.count') do
      post :create, liqour: { description: @liqour.description, distillery: @liqour.distillery, liqour_status: @liqour.liqour_status, liqour_type: @liqour.liqour_type, name: @liqour.name }
    end

    assert_redirected_to liqour_path(assigns(:liqour))
  end

  test "should show liqour" do
    get :show, id: @liqour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @liqour
    assert_response :success
  end

  test "should update liqour" do
    patch :update, id: @liqour, liqour: { description: @liqour.description, distillery: @liqour.distillery, liqour_status: @liqour.liqour_status, liqour_type: @liqour.liqour_type, name: @liqour.name }
    assert_redirected_to liqour_path(assigns(:liqour))
  end

  test "should destroy liqour" do
    assert_difference('Liqour.count', -1) do
      delete :destroy, id: @liqour
    end

    assert_redirected_to liqours_path
  end
end

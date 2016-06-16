require 'test_helper'

class DailySpecialsControllerTest < ActionController::TestCase
  setup do
    @daily_special = daily_specials(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:daily_specials)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create daily_special" do
    assert_difference('DailySpecial.count') do
      post :create, daily_special: { description: @daily_special.description, dish_type: @daily_special.dish_type, price: @daily_special.price, text: @daily_special.text, venue_id: @daily_special.venue_id }
    end

    assert_redirected_to daily_special_path(assigns(:daily_special))
  end

  test "should show daily_special" do
    get :show, id: @daily_special
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @daily_special
    assert_response :success
  end

  test "should update daily_special" do
    patch :update, id: @daily_special, daily_special: { description: @daily_special.description, dish_type: @daily_special.dish_type, price: @daily_special.price, text: @daily_special.text, venue_id: @daily_special.venue_id }
    assert_redirected_to daily_special_path(assigns(:daily_special))
  end

  test "should destroy daily_special" do
    assert_difference('DailySpecial.count', -1) do
      delete :destroy, id: @daily_special
    end

    assert_redirected_to daily_specials_path
  end
end

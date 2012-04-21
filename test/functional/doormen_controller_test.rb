require 'test_helper'

class DoormenControllerTest < ActionController::TestCase
  setup do
    @doorman = doormen(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:doormen)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create doorman" do
    assert_difference('Doorman.count') do
      post :create, doorman: { phone: @doorman.phone }
    end

    assert_redirected_to doorman_path(assigns(:doorman))
  end

  test "should show doorman" do
    get :show, id: @doorman
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @doorman
    assert_response :success
  end

  test "should update doorman" do
    put :update, id: @doorman, doorman: { phone: @doorman.phone }
    assert_redirected_to doorman_path(assigns(:doorman))
  end

  test "should destroy doorman" do
    assert_difference('Doorman.count', -1) do
      delete :destroy, id: @doorman
    end

    assert_redirected_to doormen_path
  end
end

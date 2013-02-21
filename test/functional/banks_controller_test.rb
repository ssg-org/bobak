require 'test_helper'

class BanksControllerTest < ActionController::TestCase
  setup do
    @bank = banks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:banks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bank" do
    assert_difference('Bank.count') do
      post :create, bank: { city: @bank.city, name: @bank.name }
    end

    assert_redirected_to bank_path(assigns(:bank))
  end

  test "should show bank" do
    get :show, id: @bank
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bank
    assert_response :success
  end

  test "should update bank" do
    put :update, id: @bank, bank: { city: @bank.city, name: @bank.name }
    assert_redirected_to bank_path(assigns(:bank))
  end

  test "should destroy bank" do
    assert_difference('Bank.count', -1) do
      delete :destroy, id: @bank
    end

    assert_redirected_to banks_path
  end
end

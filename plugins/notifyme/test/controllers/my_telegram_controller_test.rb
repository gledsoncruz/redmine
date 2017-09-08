require 'test_helper'

class MyTelegramControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    User.current = nil
    @request.session[:user_id] = 1 # admin
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:chats)
    assert_not_nil assigns(:pref)
  end

  def test_update
    assert_equal false, User.current.telegram_pref.no_self_notified
    assert_update_no_self_notified('1', true)
    assert_update_no_self_notified('0', false)
  end

  private

  def assert_update_no_self_notified(input_value, expected_value)
    put :update, user_telegram_preference: { no_self_notified: input_value }
    assert_redirected_to '/my/telegram'
    assert_equal expected_value, User.current.telegram_pref.no_self_notified
  end
end

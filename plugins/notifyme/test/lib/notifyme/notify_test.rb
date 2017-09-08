require 'test_helper'

module Notifyme
  class NotifyTest < ActiveSupport::TestCase
    fixtures :users

    def test_no_self_notified
      user = users(:users_002)
      TelegramChat.create!(chat_id: 12_345_678, chat_type: 'private', chat_name: 'Admin',
                           user: user)
      assert_equal false, user.telegram_pref.no_self_notified

      Notifyme::Notify.notify(content_type: :plain, content: 'Test 1!', author: user)
      assert_equal({ content_type: :plain, content: 'Test 1!', chat_ids: [12_345_678] },
                   Notifyme::TelegramBot::Senders::Fake.messages.last)

      user.telegram_pref.no_self_notified = true
      assert user.telegram_pref.save

      Notifyme::Notify.notify(content_type: :plain, content: 'Test 2!', author: user)
      assert_equal({ content_type: :plain, content: 'Test 2!', chat_ids: [] },
                   Notifyme::TelegramBot::Senders::Fake.messages.last)

      Notifyme::Notify.notify(content_type: :plain, content: 'Test 3!', author: nil)
      assert_equal({ content_type: :plain, content: 'Test 3!', chat_ids: [12_345_678] },
                   Notifyme::TelegramBot::Senders::Fake.messages.last)
    end
  end
end

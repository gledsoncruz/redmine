require 'test_helper'

module Notifyme
  module TelegramBot
    module Senders
      class FakeTest < ActiveSupport::TestCase
        def test_send
          Notifyme::TelegramBot::Bot.send_message(:plain, 'Test 1!', [12_345_678])
          assert_equal({ content_type: :plain, content: 'Test 1!', chat_ids: [12_345_678] },
                       Notifyme::TelegramBot::Senders::Fake.messages.last)

          Notifyme::TelegramBot::Bot.send_message(:html, '<b>Test 2!</b>', [])
          assert_equal({ content_type: :html, content: '<b>Test 2!</b>', chat_ids: [] },
                       Notifyme::TelegramBot::Senders::Fake.messages.last)
        end
      end
    end
  end
end

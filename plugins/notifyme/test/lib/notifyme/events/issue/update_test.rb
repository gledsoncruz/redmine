require 'test_helper'

module Notifyme
  module Events
    module Issue
      class UpdateTest < ActiveSupport::TestCase
        fixtures :issues, :issue_relations, :issue_statuses, :projects, :trackers, :users

        setup do
          Setting.plugin_notifyme = Setting.plugin_notifyme.merge(issue_update_event_notify: true)
          assert Notifyme::Settings.issue_update_event_notify
        end

        def test_strip_tags
          l = ::Notifyme::TelegramBot::Senders::Fake.messages.last
          i = ::Issue.first
          i.init_journal(::User.find(1), <<EOS)
Comentário com um título ("hX").

h2. TITULO
EOS
          i.save!
          assert_not_equal(l, ::Notifyme::TelegramBot::Senders::Fake.messages.last)
        end
      end
    end
  end
end

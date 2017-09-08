class TelegramChatsController < ApplicationController
  layout 'admin_active_scaffold'
  before_filter :require_admin

  active_scaffold :telegram_chat do |conf|
    conf.list.columns << :chat_id
    conf.show.columns << :chat_id
    conf.columns[:user].form_ui = :select
    conf.update.columns = [:user]
    conf.actions.exclude :create, :delete
  end
end

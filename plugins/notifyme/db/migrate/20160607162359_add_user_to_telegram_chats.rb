class AddUserToTelegramChats < ActiveRecord::Migration
  def change
    add_belongs_to :telegram_chats, :user
  end
end

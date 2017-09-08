class CreateTelegramChats < ActiveRecord::Migration
  def change
    create_table :telegram_chats do |t|
      t.integer :chat_id
      t.string :chat_name
      t.string :chat_type

      t.timestamps null: false
    end
  end
end

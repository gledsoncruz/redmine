module Notifyme
  module TelegramBot
    module Commands
      class UserUnset
        include AbstractCommand

        def run
          if !user_chat?
            send_no_user
          elsif !telegram_chat.user
            send_no_user_found
          else
            perform
          end
        end

        private

        def telegram_chat
          @telegram_chat ||= begin
            tc = TelegramChat.find_by(chat_id: message.chat.id)
            raise "Chat telegram não encontrado com o CHAT_ID=#{message.chat.id}" unless tc
            tc
          end
        end

        def user_chat?
          message.chat.type == 'private'
        end

        def send_no_user
          bot.api.sendMessage(chat_id: message.chat.id, text: 'Este chat não é de usuário')
        end

        def send_no_user_found
          bot.api.sendMessage(chat_id: message.chat.id, text:
              "Não há usuário vinculado ao chat Telegram \"#{telegram_chat}\".")
        end

        def perform
          u = telegram_chat.user
          telegram_chat.update_attributes!(user: nil)
          bot.api.sendMessage(chat_id: message.chat.id, text:
              "Usuário \"#{u.login}\" desvinculado do chat Telegram \"#{telegram_chat}\".")
        end
      end
    end
  end
end

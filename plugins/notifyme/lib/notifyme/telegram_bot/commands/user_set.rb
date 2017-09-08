module Notifyme
  module TelegramBot
    module Commands
      class UserSet
        include AbstractCommand

        def run
          if !user_chat?
            send_no_user
          elsif api_key.blank?
            send_no_api_key
          elsif !user
            send_no_user_found
          else
            perform
          end
        end

        private

        def api_key
          args[0]
        end

        def user
          token ||= Token.find_by(value: api_key)
          #@user ||= User.find_by(api_key: api_key)
          @user ||= token.user
        end

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

        def send_no_api_key
          bot.api.sendMessage(chat_id: message.chat.id, text:
              "Chave não informada\nUso: /userset <API_KEY>")
        end

        def send_no_user_found
          bot.api.sendMessage(chat_id: message.chat.id, text:
              "Usuário não encontrado com a chave de API \"#{api_key}\".")
        end

        def perform
          telegram_chat.update_attributes!(user: user)
          bot.api.sendMessage(chat_id: message.chat.id, text:
              "Usuário \"#{user.login}\" vinculado ao chat \"#{telegram_chat}\".")
        end
      end
    end
  end
end

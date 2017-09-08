module Notifyme
  module TelegramBot
    module Commands
      class Echo
        include AbstractCommand

        def run
          return unless send_text.present?
          bot.api.sendMessage(chat_id: message.chat.id, text: send_text)
        end

        private

        def send_text
          args.join(' ').strip
        end
      end
    end
  end
end

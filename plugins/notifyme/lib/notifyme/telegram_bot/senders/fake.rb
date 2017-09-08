module Notifyme
  module TelegramBot
    module Senders
      class Fake
        class << self
          def send_message(content_type, content, chat_ids)
            messages << {
              content_type: content_type,
              content: content,
              chat_ids: chat_ids
            }
          end

          def messages
            @messages ||= []
          end
        end
      end
    end
  end
end

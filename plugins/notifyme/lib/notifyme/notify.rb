module Notifyme
  class Notify
    class << self
      NOTIFY_REQUIRED_FIELDS = [:author, :content_type, :content].freeze

      def notify(data)
        notify_validate_required_fields(data)
        Notifyme::TelegramBot::Bot.send_message(
          data[:content_type],
          data[:content],
          chat_ids(data[:author])
        )
      end

      private

      def notify_validate_required_fields(data)
        NOTIFY_REQUIRED_FIELDS.each do |f|
          raise "Field \"#{f}\" not found in notify data: #{data}" unless data.key?(f)
        end
      end

      def chat_ids(author)
        users(author).flat_map { |u| u.telegram_chats.pluck(:chat_id) }
      end

      def users(author)
        users = TelegramChat.where.not(user: nil).joins(:user).where(
          users: { status: User::STATUS_ACTIVE }
        ).map(&:user).uniq
        return users unless author.present?
        users.select { |u| u != author || !u.telegram_pref.no_self_notified }
      end
    end
  end
end

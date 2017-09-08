require 'telegram/bot'
require 'shellwords'

module Notifyme
  module TelegramBot
    class CommandFactory
      def self.process_message(bot, message)
        command_name, args = parse_message(message)
        run_command(bot, message, command_name, args)
      rescue SystemExit => ex
        raise ex
      rescue StandardError => ex
        Rails.logger.warn ex
        bot.api.sendMessage(chat_id: message.chat.id, text: "#{ex.class}: \"#{ex}\"")
      end

      def self.parse_message(message)
        return [nil, nil] unless message && message.text
        match = %r{^/(\S+)(?:\s(.+))*}.match(message.text.strip)
        if match
          parse_command(match[1..-1].join(' ').strip)
        else
          [nil, nil]
        end
      end

      def self.run_command(bot, message, command_name, args)
        return unless command_name
        command = find_command(command_name, bot, message, args)
        if command
          command.run
        else
          bot.api.sendMessage(chat_id: message.chat.id,
                              text: "Comando não encontrado: \"#{command_name}\"")
        end
      end

      def self.parse_command(command_line)
        args = Shellwords.split(command_line)
        [args[0], args[1..-1]]
      end

      def self.find_command(command_name, bot, message, args)
        klass = command_class(command_name)
        return nil unless klass
        obj = klass.new
        obj.bot = bot
        obj.message = message
        obj.args = args
        obj
      end

      def self.command_class(command_name)
        c = Object.const_get(:Notifyme).const_get(:TelegramBot).const_get(:Commands).const_get(
          ActiveSupport::Inflector.camelize(command_name)
        )
        c.is_a?(Class) ? c : nil
      rescue NameError
        nil
      end

      def self.commands
        Dir[File.expand_path('../commands/*.rb', __FILE__)].map do |file|
          File.basename(file, '.rb')
        end
      end
    end
  end
end

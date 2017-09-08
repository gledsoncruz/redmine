require 'telegram/bot'

module Notifyme
  module TelegramBot
    module Senders
      class Real
        class << self
          def send_message(content_type, content, chat_ids)
            if content_type == :plain
              send_plain(content, chat_ids)
            elsif content_type == :html
              send_html(content, chat_ids)
            else
              raise "Unknown content type: \"#{data[:content_type]}\""
            end
          end

          private

          def send_plain(plain_text, chat_ids)
            Bot.run do |bot|
              chat_ids.each do |chat_id|
                bot.api.sendMessage(chat_id: chat_id, text: plain_text)
              end
            end
          end

          def send_html(html, chat_ids)
            file_id = nil
            chat_ids.each do |chat_id|
              if file_id
                send_photo_by_file_id(file_id, chat_id)
              else
                r = send_html_photo(html, chat_id)
                file_id = r['result']['photo'][-1]['file_id'] if r['ok']
              end
            end
          end

          def send_html_photo(html, chat_id = nil)
            send_photo(html_to_image_file(html), chat_id)
          end

          def send_photo(photo, chat_id)
            photo = Faraday::UploadIO.new(File.expand_path(photo.to_s), nil) unless
            photo.is_a?(Faraday::UploadIO)
            Bot.run do |bot|
              bot.api.sendPhoto(chat_id: chat_id, photo: photo)
            end
          end

          def send_photo_by_file_id(file_id, chat_id)
            Bot.run do |bot|
              bot.api.sendPhoto(chat_id: chat_id, photo: file_id)
            end
          end

          def html_to_image_file(html)
            kit = IMGKit.new(html, quality: 50, width: 600)
            file = Tempfile.new(['development-helper-image', '.png'])
            Faraday::UploadIO.new(kit.to_file(file.path), nil)
          end
        end
      end
    end
  end
end

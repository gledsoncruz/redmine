class TelegramChat < ActiveRecord::Base
  belongs_to :user

  def to_s
    "#{chat_name} (ID: #{chat_id}, Type: #{chat_type})"
  end
end

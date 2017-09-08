module Notifyme
  module Patches
    module UserPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.has_many :telegram_chats
      end

      module InstanceMethods
        def telegram_pref
          @telegram_pref ||= UserTelegramPreference.new(user: self)
        end
      end
    end
  end
end

unless User.included_modules.include? Notifyme::Patches::UserPatch
  User.send(:include, Notifyme::Patches::UserPatch)
end

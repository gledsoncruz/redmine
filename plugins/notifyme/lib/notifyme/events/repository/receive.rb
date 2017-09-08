module Notifyme
  module Events
    module Repository
      class Receive
        attr_reader :event

        def initialize(event)
          @event = event
        end

        def run
          return unless receive_git?
          Notifyme::Git::Repository.new(repository).notify(true)
        end

        private

        def repository
          event.data
        end

        def receive_git?
          return false unless event.entity == ::Repository && event.action == :receive
          return true if repository.is_a?(::Repository::Xitolite)
          false
        end
      end
    end
  end
end

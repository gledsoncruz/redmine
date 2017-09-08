module Heroku
  module Listeners
    module Repository
      class Receive
        attr_reader :event

        def initialize(event)
          @event = event
        end

        def run
          return unless receive_git?
          HerokuApplication.where(repository: repository).each do |app|
            Heroku::ApplicationDeploy.new(app).run
          end
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

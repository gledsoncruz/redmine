module Notifyme
  module Events
    module TimeEntry
      class Create < Base
        private

        def time_entry
          @event.data
        end

        def hours_added
          [{ add: true, hours: time_entry.hours }]
        end
      end
    end
  end
end

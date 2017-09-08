module Notifyme
  module Events
    module TimeEntry
      class Delete < Base
        private

        def time_entry
          @time_entry ||= @event.data.copy_record
        end

        def hours_added
          [{ add: false, hours: time_entry.hours }]
        end
      end
    end
  end
end

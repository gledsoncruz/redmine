module Notifyme
  module Events
    module TimeEntry
      class Update < Base
        def run
          super if hours_change
        end

        private

        def time_entry
          @event.data.record
        end

        def hours_change
          @event.data.changes[:hours]
        end

        def hours_added
          [{ add: false, hours: hours_change[0] }, { add: true, hours: hours_change[1] }]
        end
      end
    end
  end
end

module Notifyme
  module Events
    module Issue
      class Update < Base
        def journal
          @event.data
        end

        def run
          return unless Notifyme::Settings.issue_update_event_notify
          super
        end

        def issue
          journal.journalized
        end

        private

        def date
          journal.created_on.getlocal.strftime('%d/%m/%y %H:%M:%S')
        end

        def author
          journal.user
        end

        def content
          Notifyme::Utils::HtmlEncode.encode(textilizable(journal, :notes, only_path: false))
        end

        def attributes
          Notifyme::Utils::HtmlEncode.encode(
            content_tag('ul', safe_join(details_items, "\n")).to_s
          )
        end

        def details_items
          details_to_strings(journal.details, false, only_path: false).map do |s|
            content_tag('li', s)
          end
        end
      end
    end
  end
end

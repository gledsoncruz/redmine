module Notifyme
  module Events
    module Issue
      class Create < Base
        def initialize(event)
          @event = event
        end

        def issue
          @event.data
        end

        def run
          return unless Notifyme::Settings.issue_create_event_notify
          super
        end

        def date
          issue.created_on.getlocal.strftime('%d/%m/%y %H:%M:%S')
        end

        delegate :author, to: :issue

        def content
          Notifyme::Utils::HtmlEncode.encode(textilizable(issue, :description, only_path: false))
        end

        def attributes
          Notifyme::Utils::HtmlEncode.encode(render_email_issue_attributes(issue, nil, true).to_s)
        end
      end
    end
  end
end

module Notifyme
  module Events
    module TimeEntry
      class Base
        include Notifyme::Html::Base
        include ByActivity
        include ActionView::Helpers::NumberHelper

        def initialize(event)
          @event = event
        end

        def run
          Notifyme::Notify.notify(content_type: :html, content: html, author: author)
        end

        private

        def template_file
          File.expand_path('../base.html.erb', __FILE__)
        end

        def date
          time_entry.created_on.getlocal.strftime('%d/%m/%y %H:%M:%S')
        end

        def author
          time_entry.user
        end

        def hours_added_text
          hours_added.map { |t| hour_added(t) }.join(', ')
        end

        def hour_added(t)
          "<span class='#{hour_added_css_class(t)}'>#{hour_added_text(t)}</span>"
        end

        def hour_added_css_class(t)
          'hours_' + (t[:add] ? 'add' : 'sub')
        end

        def hour_added_text(t)
          (t[:add] ? '+' : '-') << l_hours(t[:hours])
        end

        def format_number(n)
          number_with_precision(n, precision: 2)
        end

        def l_hours(hours)
          l((hours < 2.0 ? :label_f_hour : :label_f_hour_plural), value: format_number(hours))
        end
      end
    end
  end
end

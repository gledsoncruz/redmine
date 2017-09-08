module Notifyme
  module Events
    module Issue
      class Base
        include Notifyme::Html::Base
        include IssuesHelper
        include CustomFieldsHelper
        include ActionView::Helpers::SanitizeHelper
        include Redmine::I18n

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

        def author
          issue.author
        end

        def content
          Notifyme::Utils::HtmlEncode.encode(textilizable(issue, :description, only_path: false))
        end
      end
    end
  end
end

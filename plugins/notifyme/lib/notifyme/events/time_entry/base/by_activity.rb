module Notifyme
  module Events
    module TimeEntry
      class Base
        module ByActivity
          def activity_table
            content_tag(:table, class: 'activity') do
              header << body
            end
          end

          def header
            content_tag(:thead) do
              b = ActiveSupport::SafeBuffer.new
              b << content_tag(:th, 'Tópico')
              activities.each do |a|
                b << content_tag(:th, a)
              end
              b << content_tag(:th, 'Total')
              b
            end
          end

          def body
            content_tag(:tbody) do
              b = ActiveSupport::SafeBuffer.new
              subjects.each { |k, v| b << subject_row(k, v) }
              b
            end
          end

          def subjects
            { issue: "##{time_entry.issue.id}",
              user_issue: "##{time_entry.issue.id} && #{time_entry.user.firstname}",
              user: "#{time_entry.user.firstname} (24hs)" }
          end

          def subject_row(k, v)
            content_tag(:tr) do
              total = 0
              b = content_tag(:th, v)
              activities.each do |a|
                hours = subject_hours(k, a)
                b << content_tag(:td, format_number(hours))
                total += hours
              end
              b << content_tag(:td, format_number(total))
            end
          end

          def subject_hours(k, a)
            send("subject_hours_#{k}", a)
          end

          def subject_hours_issue(a)
            ::TimeEntry.where(issue: time_entry.issue, activity: a).sum(:hours)
          end

          def subject_hours_user_issue(a)
            ::TimeEntry.where(user: time_entry.user, issue: time_entry.issue, activity: a)
                       .sum(:hours)
          end

          def subject_hours_user(a)
            ::TimeEntry.where(user: time_entry.user, activity: a)
                       .where('created_on > ?', 24.hours.ago)
                       .sum(:hours)
          end

          def activities
            TimeEntryActivity.all
          end

          def output_buffer=(b)
            @b = b
          end

          def output_buffer
            @b
          end
        end
      end
    end
  end
end

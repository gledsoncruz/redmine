module Notifyme
  module Git
    class HtmlBranchesGraph
      class LogLine
        def initialize(parent, info)
          @parent = parent
          @info = info
        end

        def html
          s = ''
          ERB.new(template_content, 0, '', 's').result(binding)
          Utils::HtmlEncode.encode(s)
        end

        def template_content
          File.read(File.expand_path('../log_line.html.erb', __FILE__))
        end

        def commit?
          @info[:H].blank? ? false : true
        end

        def offset
          @info[:o]
        end

        def hash
          @info[:H].blank? ? nil : @info[:H]
        end

        def short_hash
          @info[:h]
        end

        def subject
          @info[:s]
        end

        def author
          @info[:an]
        end

        def date_time
          @info[:ai]
        end

        def branches
          r = @parent.branches.select { |b| b[:branch] == hash }
                     .map { |b| b[:abbreviation] }
          return '' if r.empty?
          "< #{r.join(', ')}"
        end

        def commit_class
          return 'new' if new?
          return 'deleted' if deleted?
          'reference'
        end

        def new?
          in_branch_status?(1) && !in_branch_status?(0) && !in_branch_status?(-1)
        end

        def deleted?
          !in_branch_status?(1) && !in_branch_status?(0) && in_branch_status?(-1)
        end

        def in_branch_status?(status)
          @parent.branches.any? do |b|
            b[:status] == status && commit_in_branch?(b[:branch])
          end
        end

        def commit_in_branch?(revision)
          revision == hash || Git::Commands.descendant?(@parent.repository, revision, hash)
        end

        def commit_root?
          return false unless hash
          Git::Commands.parents(@parent.repository, hash).empty?
        end
      end
    end
  end
end

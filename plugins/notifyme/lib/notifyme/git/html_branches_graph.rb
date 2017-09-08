module Notifyme
  module Git
    class HtmlBranchesGraph
      attr_reader :repository

      SEPARATOR = '@@@'.freeze
      LOG_FORMAT = %w(H h an ai s).freeze

      def initialize(repository, branches)
        raise '"branches" is not a array' unless branches.is_a?(Array)
        raise '"branches" is empty' if branches.empty?
        @repository = repository
        @branches = branches
      end

      def output
        b = ''
        last_is_root = false
        repository.git_cmd(log_command).each_line do |l|
          b += "<hr/>\n" if last_is_root
          log_line = parse_raw_log_line(l)
          b += log_line.html
          last_is_root = log_line.commit_root?
        end
        b
      end

      def parse_raw_log_line(line)
        info = line.split(SEPARATOR)
        r = { o: HTMLEntities.new.encode(info[0], :named) }
        LOG_FORMAT.each_with_index do |v, i|
          s = info[i + 1]
          r[v.to_sym] = s ? HTMLEntities.new.encode(s.force_encoding('UTF-8'), :named) : ''
        end
        LogLine.new(self, r)
      end

      def log_command
        base = branches_merge_base
        base = base.blank? ? '' : "#{base[0, 8]}.."
        s = ['--no-pager', 'log', '--graph', "--pretty=format:#{log_format}"]
        branches.each { |b| s << "#{base}#{b[:branch]}" }
        s
      end

      def log_format
        SEPARATOR +
          LOG_FORMAT.map { |v| "%#{v}" }.join(log_line_separator) +
          SEPARATOR
      end

      def log_line_separator
        '@@@'
      end

      def branches_merge_base
        commits = branches.map { |b| b[:branch].to_s }
        base = Commands.merge_base(repository, *commits)
        return nil if base.blank?
        Commands.parents(repository, base).first
      end

      def branches
        @branches.select { |b| repository.commit_exist?(b[:branch].to_s) }
      end
    end
  end
end

module Heroku
  class Directory < String
    def on
      Dir.chdir(self) do
        yield
      end
    end

    def execute(args)
      debug_execute(args)
      on do
        Open3.popen3(*args) do |_stdin, stdout, stderr, wait_thr|
          [wait_thr.value, stdout.read, stderr.read]
        end
      end
    end

    def execute!(args)
      status, out, err = execute(args)
      if status.to_i != 0
        raise "\"#{args}\" failed\nDirectory: #{self}\nStatus: #{status}\nSTDOUT: #{out}\n" \
          "STDERR: #{err}\n"
      end
      out
    end

    def exist?
      File.exist?(self)
    end

    def mkdir_p
      Rails.logger.debug("mkdir_p: #{self}")
      FileUtils.mkdir_p(self)
    end

    def parent
      @parent ||= Directory.new(File.dirname(self))
    end

    def rm
      FileUtils.rm_r(self)
    end

    def basename
      File.basename(self)
    end

    def content?
      !(Dir.entries(self) - %w(. ..)).empty?
    end

    private

    def debug_execute(args)
      Rails.logger.debug('EXECUTE')
      Rails.logger.debug("Directory: #{self}")
      Rails.logger.debug("Args: #{args}")
    end
  end
end

module Heroku
  class Workcopy
    module HerokuExtension
      def heroku_login
        stdout_str = ''
        stderr_str = ''
        Open3.popen3(heroku_login_command) do |_stdin, stdout, stderr, _wait_thr|
          stdout_str = stdout.read
          stderr_str = stderr.read
        end
        Rails.logger.debug stdout_str
        return true if parse_login_output(stdout_str)
        Rails.logger.debug("Heroku login STDERR: #{stderr_str}")
        false
      end

      def heroku_set_remote
        status, out, err = directory.execute(['heroku', 'git:remote', '-a', app.name])
        return true if status.to_i.zero?
        Rails.logger.debug("OUT: #{out}")
        Rails.logger.debug("ERR: #{err}")
        false
      end

      def heroku_app_url
        directory.on { `heroku info -s | grep web-url | cut -d= -f2`.strip }
      end

      def heroku_deploy
        directory.execute!(['git', 'push', '-f', 'heroku',
                            "#{source_branch_revision}:refs/heads/master"])
      end

      def heroku_set_git_revision_as_app_version
        heroku_config_set('APP_VERSION', app_version)
      end

      private

      def heroku_config_set(key, value)
        directory.execute!(['heroku', 'config:set', "#{key}=#{value}"])
      end

      def parse_login_output(stdout_str)
        stdout_str.lines.each do |line|
          return true if /^\s*Logged/ =~ line
        end
        false
      end

      def heroku_login_command
        'expect -f ' + File.expand_path('../heroku_login_expect', __FILE__) +
          " '#{app.account.username}' '#{app.account.password}'"
      end
    end
  end
end

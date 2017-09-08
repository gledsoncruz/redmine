module Heroku
  module Patches
    module RepositoryPatch
      module Cloneable
        def clone_to(path)
          repos = create_temp_repository
          directory = Heroku::Directory.new(path)
          directory.parent.mkdir_p
          if directory.exist?
            directory.execute!(['git', 'remote', 'set-url', 'origin', repos])
            directory.execute!(['git', 'fetch', '-p', 'origin'])
          else
            directory.parent.execute!(['git', 'clone', repos, directory.basename])
          end
        end

        private

        def create_temp_repository
          dir = create_temp_directory
          RedmineGitHosting::Commands.sudo_capture(
            'bash', '-c',
            "(cd ~; cd #{Shellwords.escape(scm.send('repo_path'))}; " \
              "cp -R . #{Shellwords.escape(dir)})"
          )
          RedmineGitHosting::Commands.sudo_capture('chmod', 'a+rx', '-R', dir)
          dir
        end

        def create_temp_directory
          Heroku::Directory.new(RedmineGitHosting::Commands.sudo_capture('mktemp', '-d')).strip
        end
      end
    end
  end
end

module Heroku
  class Workcopy
    module GitExtension
      def update
        app.repository.clone_to(directory)
        raise "Diretório não existe: \"#{directory}\"" unless directory.exist?
        raise "Diretório vazio: \"#{directory}\"" unless directory.content?
      end

      def source_updated?
        app.last_deploy_commit != source_branch.revision
      end

      def source_branch
        @source_branch ||= begin
          return false unless app.repository.branches
          app.repository.branches.find { |b| b.to_s == app.source_branch }
        end
      end

      def origin_url
        app.repository.ssh_url
      end

      def source_branch_revision
        directory.execute!(['git', 'rev-parse', "origin/#{app.source_branch}"]).strip
      end

      def app_version
        directory.execute!(['git', '--no-pager', 'log', '--pretty=format:%h | %s | %an | %ad',
                            '--max-count=1', source_branch_revision]).strip
      end
    end
  end
end

module Notifyme
  module Git
    class OldNewBranch
      module HtmlDiff
        def html_graph
          s = ''
          ERB.new(template_content, 0, '', 's').result(binding)
          Utils::HtmlEncode.encode(s)
        end

        def html_branches_graph
          Git::HtmlBranchesGraph.new(repository, branches_to_graph)
        end

        def operation
          return 'Criado' if new?
          return 'Removido' if deleted?
          return 'Atualizado' if updated?
          'Operação não-mapeada'
        end

        private

        def branches_to_graph
          bs = [{ branch: old_rev, label: 'Antigo', abbreviation: 'A', status: -1 },
                { branch: new_rev, label: 'Novo', abbreviation: 'N', status: 1 }]
          if branch_name != 'master'
            bs << { branch: branch_master, label: 'Master', abbreviation: 'M', status: 0 }
          end
          bs.select { |b| b[:branch].present? }
        end

        def template_content
          File.read(File.expand_path('../html_diff.html.erb', __FILE__))
        end

        def branch_master
          repository.branch_revision('master')
        end
      end
    end
  end
end

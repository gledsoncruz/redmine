module Notifyme
  module Git
    class Repository
      module OldNewBranches
        def old_new_branches
          find_branches_names.map do |branch_name|
            OldNewBranch.new(@repository, branch_name)
          end
        end

        private

        def find_branches_names
          Set.new(cache_branches_names + branches_names)
        end

        def cache_branches_names
          cache_branches.map(&:name)
        end

        def branches_names
          return [] unless @repository.branches
          @repository.branches.map(&:to_s)
        end
      end
    end
  end
end

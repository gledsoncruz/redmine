module Notifyme
  module Git
    class Commands
      class << self
        def descendant?(repository, descendant, ancestor)
          base = merge_base(repository, descendant, ancestor)
          return false if base.blank?
          revparse = repository.git_cmd(['rev-parse', '--verify', ancestor]).strip
          base == revparse
        end

        def merge_base(repository, *commits)
          refs = commits.dup
          while refs.count > 1
            refs[1] = merge_base_pair(repository, refs[0], refs[1])
            return nil if refs[1].blank?
            refs.shift
          end
          refs.first
        end

        def merge_base_pair(repository, c1, c2)
          repository.git_cmd(['merge-base', c1, c2]).strip
        end

        def parents(repository, commit)
          revs = repository.git_cmd(['rev-list', '--parents', '-n', '1', commit]).split(/\s/)
          revs.shift
          revs
        end
      end
    end
  end
end

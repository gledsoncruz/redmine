module Notifyme
  module Git
    class Repository
      module Reset
        def reset
          ActiveRecord::Base.transaction do
            clear_cache_branches
            create_cache_branches
          end
        end

        private

        def clear_cache_branches
          cache_branches.each do |b|
            Rails.logger.debug("Removendo branch #{b}")
            b.destroy!
          end
        end

        def create_cache_branches
          if repository.branches
            repository.branches.each do |b|
              Rails.logger.debug("Adicionando \"#{b}\" em #{self}")
              RepositoryBranch.create!(repository: repository, name: b, revision: b.revision)
            end
          else
            Rails.logger.debug("Branches não encontrados para #{self}")
          end
        end
      end
    end
  end
end

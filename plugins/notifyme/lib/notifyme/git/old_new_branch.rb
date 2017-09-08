module Notifyme
  module Git
    class OldNewBranch
      include HtmlDiff

      attr_reader :repository, :branch_name

      def initialize(repository, branch_name)
        @repository = repository
        @branch_name = branch_name
        raise "Old and new branches doesn't exist" if old_rev.blank? && new_rev.blank?
      end

      def change?
        new? || deleted? || updated?
      end

      def new?
        old_rev.blank? && new_rev.present?
      end

      def deleted?
        old_rev.present? && new_rev.blank?
      end

      def updated?
        old_rev.present? && new_rev.present? && old_rev != new_rev
      end

      def old_rev
        b = RepositoryBranch.where(repository: repository, name: branch_name).first
        b ? b.revision : nil
      end

      def new_rev
        repository.branch_revision(branch_name)
      end

      private

      def to_s
        "[Branch: #{branch_name} / Old: \"#{old_rev}\" / New: \"#{new_rev}\"]"
      end
    end
  end
end

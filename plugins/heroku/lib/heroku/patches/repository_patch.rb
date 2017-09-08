module Heroku
  module Patches
    module RepositoryPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          alias_method_chain :to_label, :project
          alias_method_chain :to_s, :project
        end
      end

      module InstanceMethods
        include Cloneable

        def to_label_with_project
          "#{project ? project.identifier : '?'}:#{to_label_without_project}"
        end

        def to_s_with_project
          to_label_with_project
        end
      end
    end
  end
end

unless Repository.included_modules.include? Heroku::Patches::RepositoryPatch
  Repository.send(:include, Heroku::Patches::RepositoryPatch)
end

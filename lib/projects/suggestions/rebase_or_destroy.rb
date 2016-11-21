module Projects
  module Suggestions
    class RebaseOrDestroy
      BASE_BRANCH = "master"

      def self.execute(project_id)
        new(project_id).execute
      end

      def initialize(project_id)
        @project_id = project_id
      end

      def execute
        project_suggestions.each do |suggestion|
          if cant_merge?(suggestion)
            destroy_suggestion(suggestion)
          else
            destroy_suggestion(suggestion) if cant_merge_after_rebase?(suggestion)
          end
        end
      end

      private

      attr_reader :user_id, :project_id, :suggestion_id

      def project_suggestions
        Suggestion.where(project_id: project_id)
      end

      def cant_merge?(suggestion)
        !merger_for(suggestion).can_merge?
      end

      def destroy_suggestion(suggestion)
        Destroyer.execute(project_id, suggestion.id)
      end

      def cant_merge_after_rebase?(suggestion)
        !(rebase(suggestion) && merger_for(suggestion).can_merge?)
      end

      def rebase(suggestion)
        ::Projects::Git::Rebaser.rebase(repository, BASE_BRANCH, branch_name_for(suggestion))
      end

      def merger_for(suggestion)
        ::Projects::Git::Merger.new(repository, BASE_BRANCH, branch_name_for(suggestion), nil, nil)
      end

      def branch_name_for(suggestion)
        "#{suggestion.id}"
      end

      def repository
        @repository ||= Repository.for(project_id)
      end
    end
  end
end

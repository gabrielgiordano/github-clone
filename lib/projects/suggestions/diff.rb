module Projects
  module Suggestions
    class Diff
      def self.execute(project_id, suggestion_id)
        new(project_id, suggestion_id).execute
      end

      def initialize(project_id, suggestion_id)
        @project_id = project_id
        @suggestion_id = suggestion_id
      end

      def execute
        master_commit.diff(suggestion_commit).patch
      end

      private

      attr_reader :project_id, :suggestion_id

      def master_commit
        repository.branches["master"].target
      end

      def suggestion_commit
        repository.branches[suggestion_branch_name].target
      end

      def suggestion_branch_name
        "#{suggestion.id}"
      end

      def repository
        @repository ||= Repository.for(project_id)
      end

      def suggestion
        @suggestion ||= Suggestion.find(suggestion_id)
      end
    end
  end
end

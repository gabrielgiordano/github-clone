module Projects
  module Suggestions
    class Destroyer
      def self.execute(project_id, suggestion_id)
        new(project_id, suggestion_id).execute
      end

      def initialize(project_id, suggestion_id)
        @project_id = project_id
        @suggestion_id = suggestion_id
      end

      def execute
        destroy_suggestion_branch
        suggestion.destroy
      end

      private

      attr_reader :project_id, :suggestion_id

      def destroy_suggestion_branch
        repository.references.delete "refs/heads/#{suggestion_branch_name}"
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

module Projects
  module Suggestions
    class Accept
      BASE_BRANCH = "master"

      def self.execute(user_id, project_id, suggestion_id)
        new(user_id, project_id, suggestion_id).execute
      end

      def initialize(user_id, project_id, suggestion_id)
        @user_id = user_id
        @project_id = project_id
        @suggestion_id = suggestion_id
      end

      def execute
        if merger.can_merge?
          ActiveRecord::Base.transaction do
            merger.merge
            rebase_or_destroy_remaining_suggestions
            destroy_suggestion
            return true
          end
        else
          return false
        end
      end

      private

      attr_reader :user_id, :project_id, :suggestion_id, :suggestion

      def merger
        @merger ||= ::Projects::Git::Merger.new(repository, BASE_BRANCH, suggestion_branch_name, user.email, commit_message)
      end

      def destroy_suggestion
        Destroyer.execute(project_id, suggestion.id)
      end

      def rebase_or_destroy_remaining_suggestions
        RebaseOrDestroy.execute(project_id)
      end

      def suggestion_branch_name
        "#{suggestion.id}"
      end

      def commit_message
        <<~HEREDOC
          Merged suggestion #{suggestion_branch_name} into #{BASE_BRANCH}

          #{suggestion.title}
        HEREDOC
      end

      def user
        @user ||= User.find(user_id)
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

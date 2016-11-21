module Projects
  module Files
    class Destroyer
      def self.execute(user_id, project_id, file_name)
        new(user_id, project_id, file_name).execute
      end

      def initialize(user_id, project_id, file_name)
        @user_id = user_id
        @project_id = project_id
        @file_name = file_name
      end

      def execute
        ::Projects::Git::Files::Destroyer.execute(file_name, repository, "master", author_email, commit_message)
        rebase_or_destroy_remaining_suggestions
      end

      private

      attr_reader :user_id, :project_id, :file_name

      def rebase_or_destroy_remaining_suggestions
        ::Projects::Suggestions::RebaseOrDestroy.execute(project_id)
      end

      def author_email
        user.email
      end

      def commit_message
        "#{file_name} removed by #{user.email}"
      end

      def user
        @user ||= User.find user_id
      end

      def repository
        @repository ||= ::Projects::Repository.for(project_id)
      end
    end
  end
end

module Projects
  module Files
    class Creator
      def self.execute(user_id, project_id, file)
        new(user_id, project_id, file).execute
      end

      def initialize(user_id, project_id, file)
        @user_id = user_id
        @project_id = project_id
        @file = file
      end

      def execute
        if file.present?
          ::Projects::Git::Files::Creator.execute(file, repository, "master", author_email, commit_message)
          rebase_or_destroy_remaining_suggestions
        else
          return false
        end
      end

      private

      attr_reader :user_id, :project_id, :file

      def rebase_or_destroy_remaining_suggestions
        ::Projects::Suggestions::RebaseOrDestroy.execute(project_id)
      end

      def author_email
        user.email
      end

      def commit_message
        "#{file.original_filename} uploaded by #{user.email}"
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

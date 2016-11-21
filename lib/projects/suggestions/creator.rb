module Projects
  module Suggestions
    class Creator
      def self.execute(suggestion_attributes, user_id, project_id, file, file_name)
        new(suggestion_attributes, user_id, project_id, file, file_name).execute
      end

      def initialize(suggestion_attributes, user_id, project_id, file, file_name)
        @suggestion_attributes = suggestion_attributes
        @user_id = user_id
        @project_id = project_id
        @file = file
        @file_name = file_name
      end

      def execute
        if file.present?
          save_and_commit_suggestion { commit_file_in_suggestion_branch }
        else
          save_and_commit_suggestion { remove_file_in_suggestion_branch }
        end
      end

      private

      attr_reader :suggestion_attributes, :user_id, :project_id, :file, :file_name, :suggestion

      def save_and_commit_suggestion
        create_suggestion
        save_suggestion { yield } if everything_valid?
        result_of_create
      end

      def create_suggestion
        attributes = suggestion_attributes.merge(user_id: user_id, project_id: project_id)
        @suggestion = Suggestion.new(attributes)
      end

      def everything_valid?
        if suggestion.valid? && xor(file, file_name)
          return true
        else
          suggestion.errors.messages.merge!(you: [" should choose to add or remove a file."])
          return false
        end
      end

      def save_suggestion
        suggestion.transaction do
          suggestion.save!
          repository.create_branch(suggestion_branch_name)
          yield
        end
      end

      def commit_file_in_suggestion_branch
        ::Projects::Git::Files::Creator.execute(file, repository, suggestion_branch_name, author_email, commit_message)
      end

      def remove_file_in_suggestion_branch
        ::Projects::Git::Files::Destroyer.execute(file_name, repository, suggestion_branch_name, author_email, commit_message)
      end

      def suggestion_branch_name
        "#{suggestion.id}"
      end

      def author_email
        user.email
      end

      def commit_message
        if file.present?
          "#{file.original_filename} uploaded by #{user.email}"
        elsif file_name.present?
          "#{file_name} removed by #{user.email}"
        end
      end

      def result_of_create
        Suggestions::Result.new(suggestion, suggestion.errors)
      end

      def repository
        @repository ||= Repository.for(project_id)
      end

      def user
        @user ||= User.find user_id
      end

      def xor(a, b)
        (a.present? && (!b.present?)) || ((!a.present?) && b.present?)
      end
    end
  end
end

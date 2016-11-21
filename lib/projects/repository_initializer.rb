module Projects
  class RepositoryInitializer
    INITIAL_COMMIT_MESSAGE = "Initial commit"

    def self.execute(user_id, project_id)
      new(user_id, project_id).execute
    end

    def initialize(user_id, project_id)
      @user_id = user_id
      @project_id = project_id
    end

    def execute
      initialize_repository
      commit_initial_file
    end

    private

    attr_reader :repository, :user_id, :project_id

    def initialize_repository
      @repository ||= Repository.init_for(project_id)
    end

    def commit_initial_file
      Git::Files::Creator.execute(InitialFile.new, repository, nil,  author_email, INITIAL_COMMIT_MESSAGE)
    end

    def author_email
      @author_email ||= User.find(user_id).email
    end

    class InitialFile
      INITIAL_FILE_NAME = "README.md"
      INITIAL_FILE_CONTENT = "Yay! This is your first README!"

      def original_filename
        INITIAL_FILE_NAME
      end

      def read
        INITIAL_FILE_CONTENT
      end
    end
  end
end

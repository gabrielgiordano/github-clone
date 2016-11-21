module Projects
  module Files
    class Show
      def self.execute(project_id, branch, file_name)
        new(project_id, branch, file_name).execute
      end

      def initialize(project_id, branch, file_name)
        @project_id = project_id
        @branch = branch
        @file_name = file_name
      end

      def execute
        {
          name: git_file[:file][:name],
          content: git_file[:blob].content
        }
      end

      private

      attr_reader :project_id, :branch, :file_name

      def git_file
        ::Projects::Git::Files::Retriever.execute(repository, branch, file_name)
      end

      def repository
        @repository ||= ::Projects::Repository.for(project_id)
      end
    end
  end
end

module Projects
  module Files
    class Show
      def self.execute(project_id, file_name)
        new(project_id, file_name).execute
      end

      def initialize(project_id, file_name)
        @project_id = project_id
        @file_name = file_name
      end

      def execute
        {
          name: file[:name],
          content: file_content
        }
      end

      private

      attr_reader :project_id, :file_name

      def file_content
        repository.lookup(file[:oid]).content
      end

      def file
        @file ||= tree.find { |file| file[:name] == file_name }
      end

      def tree
        commit = master_branch.target
        commit.tree
      end

      def master_branch
        repository.branches["master"]
      end

      def repository
        @repository ||= ::Rugged::Repository.new("repositories/#{project.name}")
      end

      def project
        @project ||= Project.find project_id
      end
    end
  end
end

module Projects
  module Files
    class List
      def self.execute(project, branch)
        new(project, branch).execute
      end

      def initialize(project, branch)
        @project = project
        @branch = branch
      end

      def execute
        ::Projects::Git::Files::List.execute(repository, branch).map do |file|
          {
            name: file[:name]
          }
        end
      end

      private

      attr_reader :project, :branch

      def repository
        @repository ||= ::Projects::Repository.for(project.id)
      end
    end
  end
end

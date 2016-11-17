module Projects
  module Files
    class List
      def self.execute(project)
        new(project).execute
      end

      def initialize(project)
        @project = project
      end

      def execute
        tree.map do |blob|
          {
            name: blob[:name],
            oid: blob[:oid]
          }
        end
      end

      private

      attr_reader :project

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

    end
  end
end

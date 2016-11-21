module Projects
  module Git
    class Tree
      def self.for(repository, branch_name)
        new(repository, branch_name).tree
      end

      def initialize(repository, branch_name)
        @repository = repository
        @branch_name = branch_name
      end

      def tree
        commit = branch.target
        commit.tree
      end

      private

      attr_reader :repository, :branch_name

      def branch
        repository.branches[branch_name]
      end
    end
  end
end

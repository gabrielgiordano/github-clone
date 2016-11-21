module Projects
  module Git
    module Files
      class List
        def self.execute(repository, branch_name)
          new(repository, branch_name).execute
        end

        def initialize(repository, branch_name)
          @repository = repository
          @branch_name = branch_name
        end

        def execute
          tree.map do |file|
            {
              name: file[:name],
              oid: file[:oid]
            }
          end
        end

        private

        def tree
          @tree ||= Tree.for(@repository, @branch_name)
        end
      end
    end
  end
end

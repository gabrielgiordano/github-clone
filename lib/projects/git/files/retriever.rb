module Projects
  module Git
    module Files
      class Retriever
        def self.execute(repository, branch_name, file_name)
          new(repository, branch_name, file_name).execute
        end

        def initialize(repository, branch_name, file_name)
          @repository = repository
          @branch_name = branch_name
          @file_name = file_name
        end

        def execute
          {
            file: file,
            blob: blob
          }
        end

        private

        attr_reader :repository, :branch_name, :file_name

        def blob
          repository.lookup(file[:oid])
        end

        def file
          @file ||= tree.find { |file| file[:name] == file_name }
        end

        def tree
          @tree ||= Tree.for(repository, branch_name)
        end
      end
    end
  end
end

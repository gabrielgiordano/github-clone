module Projects
  module Git
    module Files
      class Destroyer
        def self.execute(file_name, repository, branch, author_email, commit_message)
          new(file_name, repository, branch, author_email, commit_message).execute
        end

        def initialize(file_name, repository, branch, author_email, commit_message)
          @file_name = file_name
          @repository = repository
          @branch = branch
          @author_email = author_email
          @commit_message = commit_message
        end

        def execute
          remove_file_from_index
          commit
        end

        private

        attr_reader :file_name, :repository, :branch, :author_email, :commit_message, :commit_tree

        def remove_file_from_index
          index.remove(file_name)
          @commit_tree = index.write_tree(repository)
        end

        def commit
          ::Projects::Git::Commiter.execute(repository, branch, commit_tree, author_email, commit_message)
        end

        def index
          @index ||= begin
            repository.index.read_tree(branch_tree)
            repository.index
          end
        end

        def branch_tree
          repository.branches[branch].target.tree
        end
      end
    end
  end
end

module Projects
  module Git
    module Files
      class Creator
        def self.execute(file, repository, branch, author_email, commit_message)
          new(file, repository, branch, author_email, commit_message).execute
        end

        def initialize(file, repository, branch, author_email, commit_message)
          @file = file
          @repository = repository
          @branch = branch
          @author_email = author_email
          @commit_message = commit_message
        end

        def execute
          stage_file
          commit_file
        end

        private

        attr_reader :file, :repository, :branch, :author_email, :commit_message, :commit_tree

        def stage_file
          oid = repository.write(file.read, :blob)
          index.add(:path => file.original_filename, :oid => oid, :mode => 0100644)
          @commit_tree = index.write_tree(repository)
        end

        def commit_file
          ::Projects::Git::Commiter.execute(repository, branch, commit_tree, author_email, commit_message)
        end

        def index
          @index ||= begin
            repository.index.read_tree(branch_tree) if branch.present?
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

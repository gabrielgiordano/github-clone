module Projects
  module Git
    class Commiter
      def self.execute(repository, branch, commit_tree, author_email, commit_message)
        new(repository, branch, commit_tree, author_email, commit_message).execute
      end

      def initialize(repository, branch, commit_tree, author_email, commit_message)
        @repository = repository
        @branch = branch
        @commit_tree = commit_tree
        @author_email = author_email
        @commit_message = commit_message
      end

      def execute
        Rugged::Commit.create(repository, commit_options)
      end

      private

      attr_accessor :repository, :branch, :commit_tree, :author_email, :commit_message

      def commit_options
        {
          tree: commit_tree,
          author: commit_author,
          committer: commit_author,
          message: commit_message,
          parents: parent_commit,
          update_ref: reference
        }
      end

      def commit_author
        { email: author_email, name: author_email, time: Time.now }
      end

      def parent_commit
        repository.empty? ? [] : [branch_last_commit].compact
      end

      def reference
        repository.empty? ? "HEAD" : "refs/heads/#{branch}"
      end

      def branch_last_commit
        repository.branches[branch].target
      end
    end
  end
end

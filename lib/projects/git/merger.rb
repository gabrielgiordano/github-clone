module Projects
  module Git
    class Merger
      def self.merge(repository, base_branch, merge_branch, author_email, commit_message)
        new(repository, base_branch, merge_branch, author_email, commit_message).merge
      end

      def initialize(repository, base_branch, merge_branch, author_email, commit_message)
        @repository = repository
        @base_branch = base_branch
        @merge_branch = merge_branch
        @author_email = author_email
        @commit_message = commit_message
      end

      def merge
        if can_merge?
          Rugged::Commit.create(repository, commit_options)
          true
        else
          false
        end
      end

      def can_merge?
        @merge_index = repository.merge_commits(base_branch_commit, merge_branch_commit)
        !merge_index.conflicts?
      end

      private

      attr_reader :repository, :base_branch, :merge_branch, :author_email, :commit_message, :merge_index

      def commit_options
        {
          parents: [base_branch_commit, merge_branch_commit],
          tree: merge_index.write_tree(repository),
          message: commit_message,
          author: commit_author,
          committer: commit_author,
          update_ref: "refs/heads/#{base_branch}"
        }
      end

      def commit_author
        { name: author_email, email: author_email }
      end

      def base_branch_commit
        @base_branch_commit ||= repository.branches[base_branch].target
      end

      def merge_branch_commit
        @merge_branch_commit ||= repository.branches[merge_branch].target
      end
    end
  end
end

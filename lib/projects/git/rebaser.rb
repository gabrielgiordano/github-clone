module Projects
  module Git
    class Rebaser
      def self.rebase(repository, base_branch, rebase_branch)
        new(repository, base_branch, rebase_branch).rebase
      end

      def initialize(repository, base_branch, rebase_branch)
        @repository = repository
        @base_branch = base_branch
        @rebase_branch = rebase_branch
      end

      def rebase
        create_temporary_branch

        rebase_branch_commits.each do |commit|
          return false unless replay_into_temporary_branch(commit)
        end

        replace_old_branch
        return true
      end

      private

      attr_reader :repository, :base_branch, :rebase_branch

      def create_temporary_branch
        repository.create_branch temporary_branch_name
      end

      def rebase_branch_commits
        reversed_commits = repository.walk(rebase_branch_commit.oid).take_while {|commit| commit.oid != merge_base}
        ordered_commits = reversed_commits.reverse
      end

      def replay_into_temporary_branch(commit)
        index = load_index
        add_diff_from_parent_to_index(commit, index)
        return false if index.conflicts?
        replay_commit(commit, index.write_tree(repository))
      end

      def add_diff_from_parent_to_index(commit, index)
        parent = commit.parents[0]
        diff = parent.diff(commit)
        diff.each_delta { |delta| index.add(delta.new_file) }
      end

      def replay_commit(commit, commit_tree)
        Commiter.execute(repository, temporary_branch_name, commit_tree, commit.author[:email], commit.message)
      end

      def replace_old_branch
        branch = "refs/heads/#{rebase_branch}"
        temporary_branch = "refs/heads/#{temporary_branch_name}"

        repository.references.delete(branch)
        repository.references.rename(temporary_branch, branch)
      end

      def temporary_branch_name
        "temporary_#{rebase_branch}"
      end

      def merge_base
        @merge_base ||= repository.merge_base(base_branch_commit, rebase_branch_commit)
      end

      def load_index
        repository.index.read_tree(base_branch_commit.tree)
        repository.index
      end

      def base_branch_commit
        @base_branch_commit ||= repository.branches[base_branch].target
      end

      def rebase_branch_commit
        @merge_branch_commit ||= repository.branches[rebase_branch].target
      end
    end
  end
end

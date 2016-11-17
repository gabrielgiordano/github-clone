module Projects
  module Files
    class Creator
      def self.execute(project_id, file)
        new(project_id, file).execute
      end

      def initialize(project_id, file)
        @project_id = project_id
        @file = file
      end

      def execute
        save_file_to_repository
        commit_file_to_master
      end

      private

      attr_reader :project_id, :file

      def save_file_to_repository
        path = File.join(repository_directory, file.original_filename)
        File.open(path, "wb") { |f| f.write(file.read) }
      end

      def commit_file_to_master
        index.add(file.original_filename)
        commit_tree = index.write_tree(repository)
        index.write

        Rugged::Commit.create repository,
          author: commit_author,
          committer: commit_author,
          message: commit_message,
          parents: [repository.head.target],
          tree: commit_tree,
          update_ref: 'HEAD'
      end

      def commit_author
        { email: "example@email.com", name: "Example", time: Time.now }
      end

      def commit_message
        '#{file.original_filename} uploaded'
      end

      def index
        repository.index
      end

      def repository
        @repository ||= ::Rugged::Repository.new(repository_directory)
      end

      def project
        @project ||= Project.find project_id
      end

      def repository_directory
        "repositories/#{project.name}"
      end
    end
  end
end

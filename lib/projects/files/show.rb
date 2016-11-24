module Projects
  module Files
    class Show
      def self.execute(project_id, branch, file_name)
        new(project_id, branch, file_name).execute
      end

      def initialize(project_id, branch, file_name)
        @project_id = project_id
        @branch = branch
        @file_name = file_name
      end

      def execute
        {
          name: git_file_name,
          content: git_file_content,
          binary: binary?
        }
      end

      private

      attr_reader :project_id, :branch, :file_name

      def git_file_name
        git_file[:file][:name]
      end

      def git_file_content
        git_file[:blob].content
      end

      def git_file
        @git_file ||= ::Projects::Git::Files::Retriever.execute(repository, branch, file_name)
      end

      def repository
        @repository ||= ::Projects::Repository.for(project_id)
      end

      def binary?
        file = Tempfile.new(git_file_name)
        File.open(file.path, "wb") { |f| f.write git_file_content }
        fm = FileMagic.new(FileMagic::MAGIC_MIME)
        fm.file(file.path) =~ /^text\// ? false : true
      end
    end
  end
end

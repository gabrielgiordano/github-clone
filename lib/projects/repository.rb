module Projects
  class Repository
    def self.init_for(project_id)
      new(project_id).init_for
    end

    def self.for(project_id)
      new(project_id).repository
    end

    def initialize(project_id)
      @project_id = project_id
    end

    def init_for
      ::Rugged::Repository.init_at(repository_directory, :bare)
    end

    def repository
      @repository ||= ::Rugged::Repository.new(repository_directory)
    end

    private

    def repository_directory
      "repositories/#{project.name}"
    end

    def project
      @project ||= Project.find @project_id
    end
  end
end

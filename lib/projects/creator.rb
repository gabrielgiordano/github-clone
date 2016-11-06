require "projects/result"

module Projects
  class Creator
    def self.execute(attributes)
      new(attributes).execute
    end

    def initialize(attributes)
      @attributes = attributes
    end

    def execute
      create_project
      save_project if project.valid?
      result_of_create
    end

    private

    attr_reader :attributes, :project

    def create_project
      @project = Project.new(attributes)
    end

    def save_project
      project.transaction do
        project.save
        user_role = UserRole.new(role: :owner, user_id: project.user.id, project_id: project.id)
        user_role.save
      end
    end

    def result_of_create
      Result.new(project, project.errors)
    end
  end
end

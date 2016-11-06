require "projects/result"

module Projects
  class Destroyer
    def self.execute(project_id)
      new(project_id).execute
    end

    def initialize(project_id)
      @project_id = project_id
    end

    def execute
      ActiveRecord::Base.transaction do
        project.destroy
        user_roles_from_project.destroy_all
      end
    end

    private

    attr_reader :project_id

    def project
      @project ||= Project.find(project_id)
    end

    def user_roles_from_project
      UserRole.where(project_id: project_id)
    end
  end
end

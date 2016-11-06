require "projects/result"

module Projects
  class Updater
    def self.execute(project_id, attributes)
      new(project_id, attributes).execute
    end

    def initialize(project_id, attributes)
      @project_id = project_id
      @attributes = attributes
    end

    def execute
      update_project
      project.save if project.valid?
      result_of_update
    end

    private

    attr_reader :project_id , :attributes

    def update_project
      project.assign_attributes(attributes)
    end

    def project
      @project ||= Project.find(project_id)
    end

    def result_of_update
      Result.new(project, project.errors)
    end
  end
end

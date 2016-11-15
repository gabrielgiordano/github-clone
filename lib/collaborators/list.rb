module Collaborators
  class List
    def self.execute(project_id)
      new(project_id).execute
    end

    def initialize(project_id)
      @project_id = project_id
    end

    def execute
      collaborators_roles.map do |collaborator_role|
        {
          user: collaborator_role.user,
          role: collaborator_role
        }
      end
    end

    private

    attr_reader :project_id

    def collaborators_roles
      UserRole.includes(:user).where(project_id: project_id)
    end
  end
end

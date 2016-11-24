module Projects
  class MyProjects
    def self.execute(user_id)
      new(user_id).execute
    end

    def initialize(user_id)
      @user_id = user_id
    end

    def execute
      user_projects.order('updated_at DESC')
    end

    private

    attr_reader :user_id

    def user_projects
      project_ids = user_roles_projects_ids + team_roles_projects_ids
      Project.where(id: project_ids)
    end

    def user_roles_projects_ids
      UserRole.where(user_id: user_id).pluck(:project_id)
    end

    def team_roles_projects_ids
      TeamRole.where(team_id: teams_with_user_ids).pluck(:project_id)
    end

    def teams_with_user_ids
      TeamsUser.where(user_id: user_id).pluck(:team_id)
    end
  end
end

module Projects
  class Role
    def initialize(user_id, project_id)
      @user_id = user_id
      @project_id = project_id
    end

    def owner?
      roles_exists? [:owner]
    end

    def writer?
      roles_exists? [:owner, :writer]
    end

    def reader?
      roles_exists? [:owner, :writer, :reader]
    end

    def collaborator?
      roles_exists? [:owner, :writer, :reader]
    end

    def roles_exists?(roles)
      user_role.where(role: roles).exists? || team_roles.where(role: roles).exists?
    end

    private

    attr_reader :user_id, :project_id

    def user_role
      UserRole.where(user_id: user_id, project_id: project_id)
    end

    def team_roles
      TeamRole.where(team_id: teams_with_user_ids, project_id: project_id)
    end

    def teams_with_user_ids
      TeamsUser.where(user_id: user_id).pluck(:team_id)
    end
  end
end

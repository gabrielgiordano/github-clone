module Projects
  class Policy
    def self.allowed?(user_id, project_id, action)
      new(user_id, project_id, action).allowed?
    end

    def self.allowed_actions(user_id, project_id)
      new(user_id, project_id, nil).allowed_actions
    end

    def initialize(user_id, project_id, action)
      @user_id = user_id
      @project_id = project_id
      @action = action&.to_sym
    end

    def allowed?
      case
      when [:index, :new, :create].include?(action) then true
      when [:edit, :update, :destroy].include?(action) then owner?
      when [:show].include?(action) then public_project? || owner?
      else false
      end
    end

    def allowed_actions
      actions = [:index, :new, :create]
      actions += [:edit, :update, :destroy, :show] if owner?
      actions += [:show] if public_project?
      actions
    end

    private

    attr_reader :user_id, :project_id, :action

    def public_project?
      project_id ? !Project.find(project_id).private? : false
    end

    def owner?
      roles_exists? [:owner]
    end

    def roles_exists?(roles)
      user_role.where(role: roles).exists?
    end

    def user_role
      UserRole.where(user_id: user_id, project_id: project_id)
    end
  end
end

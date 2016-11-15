module Collaborators
  class Policy
    def self.allowed?(user_id, project_id, user_role_id, action)
      new(user_id, project_id, user_role_id, action).allowed?
    end

    def self.allowed_actions(user_id, project_id, user_role_id)
      new(user_id, project_id, user_role_id, nil).allowed_actions
    end

    def initialize(user_id, project_id, user_role_id, action)
      @user_id = user_id
      @project_id = project_id
      @user_role_id = user_role_id
      @action = action&.to_sym
    end

    def allowed?
      case
      when [:index].include?(action) then collaborator?
      when [:create].include?(action) then owner?
      when [:update, :destroy].include?(action) then owner? && is_user_role_from_project?
      else false
      end
    end

    def allowed_actions
      actions = []
      actions += [:index] if collaborator?
      actions += [:create, :update, :destroy] if owner?
      actions
    end

    private

    attr_reader :user_id, :project_id, :user_role_id, :action

    def collaborator?
      roles_exists? [:owner, :writer, :reader]
    end

    def owner?
      roles_exists? [:owner]
    end

    def is_user_role_from_project?
      UserRole.where(id: user_role_id, project_id: project_id).exists?
    end

    def roles_exists?(roles)
      user_role.where(role: roles).exists?
    end

    def user_role
      UserRole.where(user_id: user_id, project_id: project_id)
    end
  end
end

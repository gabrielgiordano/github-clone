module Projects
  module Collaborators
    class Policy
      def self.allowed?(user_id, project_id, user_role_id, action)
        new(user_id, project_id, user_role_id, action).allowed?
      end

      def self.allowed_actions(user_id, project_id, user_role_id)
        new(user_id, project_id, user_role_id, nil).allowed_actions
      end

      def initialize(user_id, project_id, user_role_id, action)
        @project_id = project_id
        @user_role_id = user_role_id
        @action = action&.to_sym
        @role = Projects::Role.new(user_id, project_id)
      end

      def allowed?
        case
        when [:index].include?(action) then role.collaborator?
        when [:create].include?(action) then role.owner?
        when [:update, :destroy].include?(action) then role.owner? && is_user_role_from_project?
        else false
        end
      end

      def allowed_actions
        actions = []
        actions += [:index] if role.collaborator?
        actions += [:create] if role.owner?
        actions += [:update, :destroy] if role.owner? && is_user_role_from_project?
        actions
      end

      private

      attr_reader :project_id, :user_role_id, :action, :role

      def is_user_role_from_project?
        UserRole.where(id: user_role_id, project_id: project_id).exists?
      end
    end
  end
end

module Projects
  module Suggestions
    class Policy
      def self.allowed?(user_id, project_id, suggestion_id, action)
        new(user_id, project_id, suggestion_id, action).allowed?
      end

      def self.allowed_actions(user_id, project_id, suggestion_id)
        new(user_id, project_id, suggestion_id, nil).allowed_actions
      end

      def initialize(user_id, project_id, suggestion_id, action)
        @user_id = user_id
        @project_id = project_id
        @suggestion_id = suggestion_id
        @action = action&.to_sym
        @role = Projects::Role.new(user_id, project_id)
      end

      def allowed?
        case
        when [:index, :show, :show_file, :new, :create].include?(action) then public_project? || role.reader?
        when [:edit, :update].include?(action) then suggestion_owner?
        when [:destroy].include?(action) then suggestion_owner? || role.owner?
        when [:accept].include?(action) then role.owner?
        else false
        end
      end

      def allowed_actions
        actions = []
        actions += [:index, :show, :show_file, :new, :create] if public_project? || role.reader?
        actions += [:edit, :update] if suggestion_owner?
        actions += [:destroy] if suggestion_owner? || role.owner?
        actions += [:accept] if role.owner?
        actions
      end

      private

      attr_reader :user_id, :project_id, :suggestion_id, :action, :role

      def public_project?
        project_id ? !Project.find(project_id).private? : false
      end

      def suggestion_owner?
        @result_suggestion_owner ||= Suggestion.where(id: suggestion_id, user_id: user_id).exists?
      end
    end
  end
end

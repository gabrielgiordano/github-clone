module Projects
  class Policy
    def self.allowed?(user_id, project_id, action)
      new(user_id, project_id, action).allowed?
    end

    def self.allowed_actions(user_id, project_id)
      new(user_id, project_id, nil).allowed_actions
    end

    def initialize(user_id, project_id, action)
      @project_id = project_id
      @action = action&.to_sym
      @role = Projects::Role.new(user_id, project_id)
    end

    def allowed?
      case
      when [:index, :new, :create, :my_projects].include?(action) then true
      when [:destroy].include?(action) then role.owner?
      when [:edit, :update].include?(action) then role.writer?
      when [:show].include?(action) then public_project? || role.reader?
      else false
      end
    end

    def allowed_actions
      actions = [:index, :new, :create]
      actions += [:destroy] if role.owner?
      actions += [:edit, :update] if role.writer?
      actions += [:show] if public_project? || role.reader?
      actions
    end

    private

    attr_reader :project_id, :action, :role

    def public_project?
      project_id ? !Project.find(project_id).private? : false
    end
  end
end

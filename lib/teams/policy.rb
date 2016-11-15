module Teams
  class Policy
    def self.allowed?(user_id, team_id, action)
      new(user_id, team_id, action).allowed?
    end

    def self.allowed_actions(user_id, team_id)
      new(user_id, team_id, nil).allowed_actions
    end

    def initialize(user_id, team_id, action)
      @user_id = user_id
      @team_id = team_id
      @action = action&.to_sym
    end

    def allowed?
      case
      when [:index, :new, :create].include?(action) then true
      when [:edit, :update, :destroy, :show].include?(action) then team_owner?
      else false
      end
    end

    def allowed_actions
      actions = [:index, :new, :create]
      actions += [:edit, :update, :destroy, :show] if team_owner?
      actions
    end

    private

    attr_reader :user_id, :team_id, :action

    def team_owner?
      Team.where(id: team_id, user_id: user_id).exists?
    end
  end
end

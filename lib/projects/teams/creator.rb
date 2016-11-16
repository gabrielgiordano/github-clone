module Projects
  module Teams
    class Creator
      def self.execute(user_id, params)
        new(user_id, params).execute
      end

      def initialize(user_id, params)
        @user_id = user_id
        @project_id = params["project_id"]
        @name = params["name"]
        @role = params["role"]
      end

      def execute
        create_team_role
        team_role.save if team_role.valid?
        result_of_create
      end

      private

      attr_reader :user_id, :team_role, :name, :project_id, :role

      def create_team_role
        if TeamRole.roles.has_key? role
          @team_role = TeamRole.new(project_id: project_id, team_id: team.id, role: role)
        else
          @team_role = TeamRole.new(project_id: project_id, team_id: team.id)
        end
      end

      def result_of_create
        Teams::Result.new(team_role, team_role.errors)
      end

      def team
        @team ||= Team.find_by(user_id: user_id, name: name) || Team.new
      end
    end
  end
end

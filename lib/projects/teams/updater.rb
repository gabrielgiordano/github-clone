module Projects
  module Teams
    class Updater
      def self.execute(team_role_id, role)
        new(team_role_id, role).execute
      end

      def initialize(team_role_id, role)
        @team_role_id = team_role_id
        @role = role
      end

      def execute
        fetch_team_role

        team_role.transaction do
          update_team_role
          team_role.save if team_role.valid?
        end

        result_of_update
      end

      private

      attr_reader :team_role_id, :role, :team_role

      def fetch_team_role
        @team_role = TeamRole.find(team_role_id) || TeamRole.new
      end

      def update_team_role
        @team_role.role = role if TeamRole.roles.has_key? role
      end

      def result_of_update
        Teams::Result.new(team_role, team_role.errors)
      end
    end
  end
end

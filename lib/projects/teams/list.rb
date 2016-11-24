module Projects
  module Teams
    class List
      def self.execute(project_id)
        new(project_id).execute
      end

      def initialize(project_id)
        @project_id = project_id
      end

      def execute
        team_roles.map do |team_role|
          {
            team: team_role.team,
            role: team_role
          }
        end
      end

      private

      attr_reader :project_id

      def team_roles
        TeamRole.includes(:team).where(project_id: project_id).order('updated_at DESC')
      end
    end
  end
end

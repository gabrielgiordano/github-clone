module Projects
  module Teams
    class Destroyer
      def self.execute(team_role_id)
        new(team_role_id).execute
      end

      def initialize(team_role_id)
        @team_role_id = team_role_id
      end

      def execute
        if team_role
          team_role.destroy
          Result.new(true)
        else
          Result.new(false)
        end
      end

      private

      attr_reader :team_role_id

      def team_role
        @team_role ||= TeamRole.where(id: team_role_id).first
      end

      def result_of_deletion
        Result.new(@messages)
      end

      class Result
        def initialize(result)
          @result = result
        end

        def successful?
          @result
        end
      end
    end
  end
end

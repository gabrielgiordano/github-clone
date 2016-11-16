module Projects
  module Teams
    class Result
      attr_reader :team_role, :messages

      def initialize(team_role, messages)
        @team_role = team_role
        @messages = messages
      end

      def successful?
        messages.empty?
      end
    end
  end
end

module Projects
  module Collaborators
    class Result
      attr_reader :user_role, :messages

      def initialize(user_role, messages)
        @user_role = user_role
        @messages = messages
      end

      def successful?
        messages.empty?
      end
    end
  end
end

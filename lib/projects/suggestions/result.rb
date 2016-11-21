module Projects
  module Suggestions
    class Result
      attr_reader :suggestion, :messages

      def initialize(suggestion, messages)
        @suggestion = suggestion
        @messages = messages
      end

      def successful?
        messages.empty?
      end
    end
  end
end

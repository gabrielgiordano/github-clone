module Teams
  class Result
    attr_reader :team, :messages

    def initialize(team, messages)
      @team = team
      @messages = messages
    end

    def successful?
      messages.empty?
    end
  end
end

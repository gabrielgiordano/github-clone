module Projects
  class Result
    attr_reader :project, :messages

    def initialize(project, messages)
      @project = project
      @messages = messages
    end

    def successful?
      messages.empty?
    end
  end
end

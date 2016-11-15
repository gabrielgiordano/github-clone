module Teams
  class Creator
    def self.execute(attributes)
      new(attributes).execute
    end

    def initialize(attributes)
      @attributes = attributes
    end

    def execute
      create_team
      team.save if team.valid?
      result_of_create
    end

    private

    attr_reader :attributes, :team

    def create_team
      @team = Team.new(attributes)
    end

    def result_of_create
      Result.new(team, team.errors)
    end
  end
end

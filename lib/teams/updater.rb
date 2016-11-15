module Teams
  class Updater
    def self.execute(team_id, attributes)
      new(team_id, attributes).execute
    end

    def initialize(team_id, attributes)
      @team_id = team_id
      @attributes = attributes
    end

    def execute
      update_team
      team.save if team.valid?
      result_of_update
    end

    private

    attr_reader :team_id, :attributes

    def update_team
      team.assign_attributes(attributes)
    end

    def team
      @team ||= Team.find(team_id)
    end

    def result_of_update
      Result.new(team, team.errors)
    end
  end
end

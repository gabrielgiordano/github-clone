module Teams
  class Destroyer
    def self.execute(team_id)
      new(team_id).execute
    end

    def initialize(team_id)
      @team_id = team_id
    end

    def execute
      ActiveRecord::Base.transaction do
        delete_associations_with_projects
        team.destroy
      end
    end

    private

    attr_reader :team_id

    def delete_associations_with_projects
      TeamRole.where(team_id: team.id).destroy_all
    end

    def team
      @team ||= Team.find(team_id)
    end
  end
end

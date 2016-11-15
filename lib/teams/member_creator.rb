module Teams
  class MemberCreator
    def self.execute(team_id, email)
      new(team_id, email).execute
    end

    def initialize(team_id, email)
      @team_id = team_id
      @email = email
      @messages = []
    end

    def execute
      run_validations
      team.members << member if everything_ok?
      result_of_creation
    end

    private

    attr_reader :team_id, :email

    def run_validations
      @messages << "Couldn't find user" unless team.present? && member.present?
      @messages << "User already inside team" if team.members.include?(member)
    end

    def everything_ok?
      @messages.empty?
    end

    def team
      @team ||= Team.find(team_id)
    end

    def member
      @member ||= User.where(email: email)
    end

    def result_of_creation
      Result.new(team, @messages)
    end
  end
end

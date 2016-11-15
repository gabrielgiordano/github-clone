module Teams
  class MemberDestroyer
    def self.execute(team_id, user_id)
      new(team_id, user_id).execute
    end

    def initialize(team_id, user_id)
      @team_id = team_id
      @user_id = user_id
      @messages = []
    end

    def execute
      run_validations
      remove_team_member if everything_ok?
      deletion_result
    end

    private

    attr_reader :team_id, :user_id

    def run_validations
      @messages << "Couldn't find user" unless team.present? && member.present?
      @messages << "User does not belong to team" unless team.members.include?(member)
    end

    def everything_ok?
      @messages.empty?
    end

    def remove_team_member
      ActiveRecord::Base.transaction { team.members.delete(member) }
    end

    def team
      @team ||= Team.find(team_id)
    end

    def member
      @member ||= User.find(user_id)
    end

    def deletion_result
      Result.new(team, @messages)
    end
  end
end

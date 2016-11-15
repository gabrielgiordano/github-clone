module Teams
  class List
    def self.execute(user_id)
      new(user_id).execute
    end

    def initialize(user_id)
      @user_id = user_id
    end

    def execute
      Team.where(user_id: @user_id)
    end
  end
end

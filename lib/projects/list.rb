module Projects
  class List
    def self.execute(user_id)
      new(user_id).execute
    end

    def initialize(user_id)
      @user_id = user_id
    end

    def execute
      visible_projects_for_user
    end

    private

    attr_reader :user_id

    def visible_projects_for_user
      user_projects.or(public_projects)
    end

    def user_projects
      Project.where(user_id: user_id)
    end

    def public_projects
      Project.where(private: false)
    end
  end
end

module Collaborators
  class Creator
    def self.execute(params)
      new(params).execute
    end

    def initialize(params)
      @project_id = params["project_id"]
      @email = params["email"]
      @role = params["role"]
    end

    def execute
      create_user_role
      user_role.save if user_role.valid?
      result_of_create
    end

    private

    attr_reader :user_role, :email, :project_id, :role

    def create_user_role
      if UserRole.roles.has_key? role
        @user_role = UserRole.new(project_id: project_id, user_id: user.id, role: role)
      else
        @user_role = UserRole.new(project_id: project_id, user_id: user.id)
      end
    end

    def result_of_create
      Result.new(user_role, user_role.errors)
    end

    def user
      @user ||= User.find_by(email: email) || User.new
    end
  end
end

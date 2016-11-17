module Projects
  class Creator
    def self.execute(project_attributes, user_id)
      new(project_attributes, user_id).execute
    end

    def initialize(project_attributes, user_id)
      @project_attributes = project_attributes
      @user_id = user_id
    end

    def execute
      create_project
      save_project if project.valid?
      result_of_create
    end

    private

    attr_reader :project_attributes, :user_id, :project

    def create_project
      @project = Project.new(project_attributes)
    end

    def save_project
      project.transaction do
        project.save
        save_user_role
        create_repository
      end
    end

    def save_user_role
      user_role = UserRole.new(role: :owner, user_id: user_id, project_id: project.id)
      user_role.save
    end

    def create_repository
      ::Rugged::Repository.init_at("repositories/#{project.name}")
    end

    def result_of_create
      Result.new(project, project.errors)
    end
  end
end

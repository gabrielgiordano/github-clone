module Projects
  class TeamsController < ApplicationController
    before_action :authenticate_user!
    before_action -> { authorize_user_with(::Projects::Teams::Policy, current_user.id, project_id, team_role_id, action_name) }
    before_action :set_project_id

    def index
      load_team_roles
    end

    def create
      creation = Teams::Creator.execute(current_user.id, team_params)

      respond_to do |format|
        if creation.successful?
          format.html { redirect_to project_teams_url, notice: "Team was successfully added." }
        else
          load_team_roles
          setup_error_from(creation)
          format.html { render :index }
        end
      end
    end

    def update
      update = Teams::Updater.execute(*update_team_params)

      respond_to do |format|
        if update.successful?
          format.html { redirect_to project_teams_url, notice: "Team was successfully updated." }
        else
          format.html { redirect_to project_teams_url, notice: update.messages.full_messages.join("\n") }
        end
      end
    end

    def destroy
      deletion = Teams::Destroyer.execute(team_role_id)

      respond_to do |format|
        if deletion.successful?
          format.html { redirect_to project_teams_url, notice: 'Team was successfully removed.' }
        else
          format.html { redirect_to project_teams_url, notice: 'Team was not removed.' }
        end
      end
    end

    private

    def load_team_roles
      @team_roles = Teams::List.execute(project_id)
    end

    def setup_error_from(result)
      @team_role = result.team_role
      flash.now[:alert] = result.messages
    end

    def team_params
      params.permit(:id, :project_id, :name, :role, { selected_team_role: :role })
    end

    def update_team_params
      [team_role_id, team_params["selected_team_role"]["role"]]
    end

    def project_id
      team_params["project_id"]
    end

    def team_role_id
      team_params["id"]
    end

    def set_project_id
      @project_id = project_id
      @project = Project.find project_id
    end
  end
end

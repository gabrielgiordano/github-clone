class ProjectCollaboratorsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { authorize_user_with(Collaborators::Policy, current_user.id, project_id, user_role_id, action_name) }
  before_action :set_project_id

  def index
    load_collaborators
  end

  def create
    creation = Collaborators::Creator.execute(collaborator_params)

    respond_to do |format|
      if creation.successful?
        format.html { redirect_to project_collaborators_url, notice: "Collaborator was successfully added." }
      else
        load_collaborators
        setup_error_from(creation)
        format.html { render :index }
      end
    end
  end

  def update
    update = Collaborators::Updater.execute(*update_collaborator_params)

    respond_to do |format|
      if update.successful?
        format.html { redirect_to project_collaborators_url, notice: "Collaborator was successfully updated." }
      else
        format.html { redirect_to project_collaborators_url, notice: update.messages.full_messages.join("\n") }
      end
    end
  end

  def destroy
    deletion = Collaborators::Destroyer.execute(user_role_id)

    respond_to do |format|
      if deletion.successful?
        format.html { redirect_to project_collaborators_url, notice: 'Collaborator was successfully removed.' }
      else
        format.html { redirect_to project_collaborators_url, notice: deletion.messages.first }
      end
    end
  end

  private

  def load_collaborators
    @collaborators = Collaborators::List.execute(project_id)
  end

  def setup_error_from(result)
    @user_role = result.user_role
    flash.now[:alert] = result.messages
  end

  def update_collaborator_params
    [user_role_id, collaborator_params["selected_user_role"]["role"]]
  end

  def collaborator_params
    params.permit(:id, :project_id, :email, :role, { selected_user_role: :role })
  end

  def set_project_id
    @project_id = project_id
  end

  def project_id
    collaborator_params["project_id"]
  end

  def user_role_id
    collaborator_params["id"]
  end
end

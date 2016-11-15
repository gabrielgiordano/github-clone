class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action -> { authorize_user_with(Projects::Policy, current_user&.id, project_id, action_name) }

  def index
    @projects = Projects::List.execute(current_user&.id)
  end

  def new
    @project = Project.new
  end

  def create
    creation = Projects::Creator.execute(project_params, current_user.id)

    respond_to do |format|
      if creation.successful?
        format.html { redirect_to creation.project, notice: 'Project was successfully created.' }
      else
        setup_error_from(creation)
        format.html { render :new }
      end
    end
  end

  def edit
    @project = Project.find(project_id)
  end

  def update
    update = Projects::Updater.execute(project_id, project_params)

    respond_to do |format|
      if update.successful?
        format.html { redirect_to update.project, notice: 'Project was successfully updated.' }
      else
        setup_error_from(update)
        format.html { render :edit }
      end
    end
  end

  def show
    @project = Project.find(project_id)
  end

  def destroy
    Projects::Destroyer.execute(project_id)

    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :private)
  end

  def project_id
    params[:id]
  end

  def setup_error_from(result)
    @project = result.project
    flash.now[:alert] = result.messages
  end
end

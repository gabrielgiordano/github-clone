class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { authorize_user_with(Teams::Policy, current_user.id, team_id, action_name) }

  def index
    @teams = Teams::List.execute(current_user.id)
  end

  def new
    @team = Team.new
  end

  def create
    creation = Teams::Creator.execute(team_params.merge(user_id: current_user.id))

    respond_to do |format|
      if creation.successful?
        format.html { redirect_to creation.team, notice: 'Team was successfully created.' }
      else
        setup_error_from(creation)
        format.html { render :new }
      end
    end
  end

  def edit
    @team = Team.find(team_id)
  end

  def update
    update = Teams::Updater.execute(team_id, team_params)

    respond_to do |format|
      if update.successful?
        format.html { redirect_to update.team, notice: 'Team was successfully updated.' }
      else
        setup_error_from(update)
        format.html { render :edit }
      end
    end
  end

  def show
    @team = Team.find(team_id)
  end

  def destroy
    Teams::Destroyer.execute(team_id)

    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :email)
  end

  def team_id
    params[:id]
  end

  def setup_error_from(result)
    @team = result.team
    flash.now[:alert] = result.messages
  end
end

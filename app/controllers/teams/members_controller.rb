module Teams
  class MembersController < ApplicationController
    before_action :authenticate_user!
    before_action -> { authorize_user_with(Members::Policy, current_user.id, team_id, action_name) }

    def create
      creation = Members::Creator.execute(team_id, team_params["email"])

      respond_to do |format|
        if creation.successful?
          format.html { redirect_to creation.team, notice: "Member was successfully added." }
        else
          format.html { redirect_to creation.team, notice: creation.messages.first }
        end
      end
    end

    def destroy
      deletion = Members::Destroyer.execute(team_id, team_params["user_id"])

      respond_to do |format|
        if deletion.successful?
          format.html { redirect_to deletion.team, notice: "Member was successfully removed." }
        else
          format.html { redirect_to deletion.team, notice: deletion.messages.first }
        end
      end
    end

    private

    def team_params
      params.permit(:team_id, :email, :user_id)
    end

    def team_id
      team_params[:team_id]
    end
  end
end

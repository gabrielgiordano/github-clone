module Projects
  class SuggestionsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show, :show_file]
    before_action -> { authorize_user_with(Suggestions::Policy, current_user&.id, project_id, suggestion_id, action_name) }
    before_action :set_suggestion, only: [:edit, :update, :destroy]
    before_action :set_project_id

    def index
      @suggestions = Suggestion.all
    end

    def show
      @suggestion = Suggestion.find(suggestion_id)
      @diff = Suggestions::Diff.execute(project_id, suggestion_id)
    end

    def show_file
      @suggestion_id = suggestion_id
      @file = Suggestions::Files::Show.execute(project_id, suggestion_id, file_name)
    end

    def new
      @suggestion = Suggestion.new
    end

    def create
      creation = Suggestions::Creator.execute(suggestion_attributes, current_user.id, project_id, file, file_name)
      @suggestion = creation.suggestion

      respond_to do |format|
        if creation.successful?
          format.html { redirect_to project_suggestion_path(project_id, @suggestion), notice: "Suggestion was successfully created." }
        else
          format.html { render :new }
        end
      end
    end

    def edit
    end

    def update
      respond_to do |format|
        if @suggestion.update(suggestion_attributes)
          format.html { redirect_to project_suggestion_path(project_id, @suggestion), notice: 'Suggestion was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      deletion = Suggestions::Destroyer.execute(project_id, suggestion_id)

      respond_to do |format|
        format.html { redirect_to project_suggestions_url(project_id), notice: 'Suggestion was successfully destroyed.' }
      end
    end

    def accept
      result = Suggestions::Accept.execute(current_user.id, project_id, suggestion_id)

      respond_to do |format|
        if result
          format.html { redirect_to project_url(project_id), notice: "Suggestion was successfully accepted." }
        else
          format.html { redirect_to project_suggestions_url(project_id), notice: "Can't accept suggestion." }
        end
      end
    end

    private
      def set_suggestion
        @suggestion = Suggestion.find(suggestion_id)
      end

      def set_project_id
        @project_id = project_id
        @project = Project.find(project_id)
      end

      def suggestion_params
        params.permit(:project_id, :title, :description, :file, :file_name)
      end

      def suggestion_attributes
        suggestion_params.slice(:title, :description)
      end

      def file
        suggestion_params[:file]
      end

      def file_name
        suggestion_params[:file_name]
      end

      def suggestion_id
        params[:id] || params[:suggestion_id]
      end

      def project_id
        suggestion_params["project_id"]
      end
  end
end

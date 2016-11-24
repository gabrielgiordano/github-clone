module Projects
  class FilesController < ApplicationController
    before_action :authenticate_user!, except: [:show]
    before_action -> { authorize_user_with(Files::Policy, current_user&.id, project_id, action_name) }
    before_action :set_project_id

    def new
    end

    def show
      @file = Files::Show.execute(project_id, "master", file_name)

      respond_to do |format|
        format.html { render :show }
      end
    end

    def download
      file = Files::Show.execute(project_id, "master", file_name)
      file_extension = File.extname(file[:name])[1..-1]

      send_data file[:content], filename: file[:name], type: "application/#{file_extension}"
    end

    def create
      creation = Files::Creator.execute(current_user.id, project_id, files_params[:file])

      if creation
        flash[:notice] = "File uploaded"
      else
        flash[:notice] = "File missing"
      end

      redirect_to project_url(project_id)
    end

    def destroy
      Files::Destroyer.execute(current_user.id, project_id, file_name)
      flash[:notice] = "File destroyed"
      redirect_to project_url(project_id)
    end

    private

    def set_project_id
      @project_id = project_id
      @project = Project.find(project_id)
    end

    def files_params
      params.permit(:file_name, :project_id, :file)
    end

    def file_name
      files_params["file_name"]
    end

    def project_id
      files_params["project_id"]
    end
  end
end

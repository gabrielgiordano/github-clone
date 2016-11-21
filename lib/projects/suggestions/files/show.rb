module Projects
  module Suggestions
    module Files
      class Show
        def self.execute(project_id, suggestion_id, file_name)
          new(project_id, suggestion_id, file_name).execute
        end

        def initialize(project_id, suggestion_id, file_name)
          @project_id = project_id
          @suggestion_id = suggestion_id
          @file_name = file_name
        end

        def execute
          @file = ::Projects::Files::Show.execute(project_id, suggestion_branch_name, file_name)
        end

        private

        attr_reader :project_id, :suggestion_id, :file_name

        def suggestion_branch_name
          "#{suggestion_id}"
        end

        def project
          @project ||= Project.find project_id
        end
      end
    end
  end
end

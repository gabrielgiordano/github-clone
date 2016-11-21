module Projects
  module Suggestions
    module Files
      class List
        def self.execute(project_id, suggestion_id)
          new(project_id, suggestion_id).execute
        end

        def initialize(project_id, suggestion_id)
          @project_id = project_id
          @suggestion_id = suggestion_id
        end

        def execute
          ::Projects::Files::List.execute(project, suggestion_branch_name)
        end

        private

        attr_reader :project_id, :suggestion_id

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

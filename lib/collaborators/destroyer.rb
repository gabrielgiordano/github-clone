module Collaborators
  class Destroyer
    def self.execute(user_role_id)
      new(user_role_id).execute
    end

    def initialize(user_role_id)
      @user_role_id = user_role_id
      @messages = []
    end

    def execute
      if is_there_remaining_owner?
        user_role.destroy
      else
        @messages << "Can't remove last owner"
      end

      result_of_deletion
    end

    private

    attr_reader :user_role_id

    def user_role
      @user_role ||= UserRole.includes(:project).find(user_role_id)
    end

    def is_there_remaining_owner?
      UserRole.where.not(id: user_role.id).where(project: user_role.project, role: :owner).exists?
    end

    def result_of_deletion
      Result.new(@messages)
    end

    class Result
      attr_reader :messages

      def initialize(messages)
        @messages = messages
      end

      def successful?
        messages.empty?
      end
    end
  end
end

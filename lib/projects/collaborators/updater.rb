module Projects
  module Collaborators
    class Updater
      def self.execute(user_role_id, role)
        new(user_role_id, role).execute
      end

      def initialize(user_role_id, role)
        @user_role_id = user_role_id
        @role = role
      end

      def execute
        fetch_user_role

        user_role.transaction do
          update_user_role
          user_role.save if validate_user_role
        end

        result_of_update
      end

      private

      attr_reader :user_role_id, :role, :user_role

      def fetch_user_role
        @user_role = UserRole.find(user_role_id) || UserRole.new
      end

      def validate_user_role
        if user_role.valid? && (will_be_owner? || is_there_another_owner?)
          return true
        else
          user_role.errors.messages.merge!(last_owner: ["cannot be removed"])
          return false
        end
      end

      def will_be_owner?
        user_role.role == "owner"
      end

      def is_there_another_owner?
        UserRole.where.not(id: user_role.id).where(project: user_role.project, role: :owner).exists?
      end

      def update_user_role
        @user_role.role = role if UserRole.roles.has_key? role
      end

      def result_of_update
        Collaborators::Result.new(user_role, user_role.errors)
      end
    end
  end
end

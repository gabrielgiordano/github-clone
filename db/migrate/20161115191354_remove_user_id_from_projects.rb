class RemoveUserIdFromProjects < ActiveRecord::Migration[5.0]
  def change
    remove_column :projects, :user_id
  end
end

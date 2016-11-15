class CreateJoinTableUserTeam < ActiveRecord::Migration[5.0]
  def change
    create_table :teams_users do |t|
      t.references :team, null: false, on_delete: :cascade, on_update: :restrict, foreign_key: true
      t.references :user, null: false, on_delete: :cascade, on_update: :restrict, foreign_key: true
    end

    add_index :teams_users, [:team_id, :user_id]
    add_index :teams_users, [:user_id, :team_id]
  end
end

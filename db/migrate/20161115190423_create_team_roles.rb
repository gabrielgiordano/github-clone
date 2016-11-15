class CreateTeamRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :team_roles do |t|
      t.integer :role, null: false
      t.references :team, null: false, index: true, on_delete: :cascade, on_update: :restrict, foreign_key: true
      t.references :project, null: false, index: true, on_delete: :cascade, on_update: :restrict, foreign_key: true

      t.timestamps
    end
  end
end

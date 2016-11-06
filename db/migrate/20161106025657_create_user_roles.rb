class CreateUserRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_roles do |t|
      t.integer :role, null: false
      t.references :user, null: false, index: true, on_delete: :cascade, on_update: :restrict, foreign_key: true
      t.references :project, null: false, index: true, on_delete: :cascade, on_update: :restrict, foreign_key: true

      t.timestamps
    end

    add_index :user_roles, :role
  end
end

class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :description
      t.boolean :private
      t.references :user, null: false, index: true, on_delete: :cascade, on_update: :restrict, foreign_key: true

      t.timestamps
    end

    add_index :projects, :name
  end
end

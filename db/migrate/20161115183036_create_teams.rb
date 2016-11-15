class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.references :user, null: false, index: true, on_delete: :cascade, on_update: :restrict, foreign_key: true
      t.timestamps
    end
  end
end

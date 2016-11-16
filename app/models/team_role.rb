class TeamRole < ApplicationRecord
  enum role: { owner: 0, writer: 1, reader: 2 }

  belongs_to :team
  belongs_to :project

  validates :role, presence: true
  validates :team, uniqueness: { scope: :project }
end

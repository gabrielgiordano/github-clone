class UserRole < ApplicationRecord
  enum role: { owner: 0, reader: 1, writer: 2 }

  belongs_to :user
  belongs_to :project

  validates :role, presence: true
  validates :user, uniqueness: { scope: :project }
end

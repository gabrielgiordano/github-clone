class UserRole < ApplicationRecord
  enum role: { owner: 0, writer: 1, reader: 2 }

  belongs_to :user
  belongs_to :project

  validates :role, presence: true
  validates :user, uniqueness: { scope: :project }
end

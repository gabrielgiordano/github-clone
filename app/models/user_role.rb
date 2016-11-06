class UserRole < ApplicationRecord
  enum role: { owner: 0 }

  belongs_to :user
  belongs_to :project

  validates :role, presence: true
end

class Team < ApplicationRecord
  # Team owner
  belongs_to :user
  alias_method :owner, :user

  # Team members
  has_and_belongs_to_many :users
  alias_method :members, :users

  validates :name, presence: true, uniqueness: true
end

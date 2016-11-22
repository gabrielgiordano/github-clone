class Project < ApplicationRecord
  POSIX_FILE_NAME_REGEX = /\A[\-\_\w]+\Z/

  validates :name, format: { with: POSIX_FILE_NAME_REGEX, message: "should be a POSIX file name without dots" }
  validates :name, uniqueness: true
  validates :name, :description, presence: true
end

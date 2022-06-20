class Tag < ApplicationRecord
  has_many :task_tags, dependent: :destroy
  has_many :tasks, through: :task_tags

  validates :name, uniqueness: true, length: {minimum: 1, maximum: 10}
end

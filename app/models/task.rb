class Task < ApplicationRecord
  belongs_to :customer
  has_many :task_comments, dependent: :destroy

  validates :title, presence: true
end

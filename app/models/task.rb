class Task < ApplicationRecord
  belongs_to :customer
  has_many :task_comments, dependent: :destroy

  validates :title, presence: true

  enum progress_status: { notReady: 0, Ready: 1, Doing: 2, Done: 3 }
end
